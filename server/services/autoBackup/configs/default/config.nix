{ config, lib, pkgs-default, ... }:
{
  config = lib.mkIf (config.server.services.autoBackup.enable && (config.server.services.autoBackup.activeConfig == "default")) {
    
    environment.systemPackages = let
  # --- Configuration Variables ---
  # Adjust these paths to match your actual system secrets and paths
  rcloneConfigPath = config.sops.secrets."rclone_config".path;
  resticPasswordPath = config.sops.secrets."restic_password".path;
  
  # The dataset root where .zfs/snapshots are located
  localDataRoot = "/data"; 
  
  # The ZFS dataset name for creating snapshots
  zfsDataset = "zroot/root/data";

  # Restic Repo definition
  resticRepo = "rclone:gdrive:nixos-backup";

  # The systemd service to start for online backups
  resticService = "restic-backups-gdrive-backup";

  manageBackupsScript = pkgs.writeShellScriptBin "manageBackups" ''
    # --- Dependencies & Environment Setup ---
    export PATH="${pkgs.gum}/bin:${pkgs.coreutils}/bin:${pkgs.zfs}/bin:${pkgs.restic}/bin:${pkgs.rclone}/bin:${pkgs.rsync}/bin:$PATH"
    
    # Root Check
    if [ "$EUID" -ne 0 ]; then
      exec sudo "$0" "$@"
    fi

    # Secrets & Configs
    export RCLONE_CONFIG="${rcloneConfigPath}"
    RESTIC_PWD_FILE="${resticPasswordPath}"
    
    # Base Command
    RESTIC_CMD="restic -r ${resticRepo} --password-file $RESTIC_PWD_FILE"

    # Defaults
    DEFAULT_MOUNT="/mnt/restoreTemp"
    LOCAL_ROOT="${localDataRoot}"
    SNAPSHOT_DIR=".zfs/snapshot"

    # --- Helper Functions ---

    log() { echo "  $1"; }
    
    # The file picker inspired by the prompt
    gpick() {
        local start_dir="$1"
        local selection
        
        # Save current dir to return later
        pushd "$start_dir" > /dev/null

        while true; do
            # List contents: 
            # -1ap: 1 column, all files, classify (add / to dirs)
            # sed: Make ./ clickable as "Pick Current Directory"
            selection=$(ls -1ap | sed 's/^\.\/$/\. (Pick Current Directory)/' | gum filter \
                --height 15 \
                --indicator=">" \
                --header "📂 $PWD" \
                --placeholder "Browse files (Enter to go deeper, Esc to cancel)..." \
            )

            # Handle Cancel
            if [[ -z "$selection" ]]; then
                popd > /dev/null
                return 1
            fi

            # Logic
            if [[ "$selection" == ". (Pick Current Directory)" ]]; then
                echo "$PWD"
                popd > /dev/null
                return 0
            elif [[ "$selection" == */ ]]; then
                # Directory -> Enter it
                cd "$selection" || return
            else
                # File -> Return full path
                echo "$PWD/$selection"
                popd > /dev/null
                return 0
            fi
        done
    }

    # Logic to restore a file/folder to /data
    # Arguments: $1 = Source Path, $2 = Base Path to strip (e.g., mount point or .zfs path)
    perform_restore() {
        local src="$1"
        local base_strip="$2"
        
        # Calculate relative path. 
        # Example src: /mnt/restore/snapshots/latest/home/user/file
        # Base strip: /mnt/restore/snapshots/latest
        # Relative: /home/user/file
        # Target: /data/home/user/file
        
        # We assume the structure inside the snapshot mirrors root or data root.
        # This logic attempts to strip the snapshot prefix and map it to LOCAL_ROOT
        
        # 1. Get the path relative to the snapshot root
        # We need to find where the actual file tree starts. 
        # For ZFS: /data/.zfs/snapshot/SNAP_NAME/ -> contents
        # For Restic: /mnt/restore/snapshots/SNAP_ID/ -> contents
        
        local relative_path="''${src#$base_strip}"
        
        # Remove leading slash if present
        relative_path="''${relative_path#/}"
        
        local dest="$LOCAL_ROOT/$relative_path"

        echo ""
        gum style --foreground 212 "SOURCE: $src"
        gum style --foreground 212 "TARGET: $dest"
        echo ""

        if [ -e "$dest" ]; then
            if ! gum confirm "Destination exists. Overwrite?"; then
                echo "❌ Restore cancelled."
                return
            fi
        fi

        gum spin --spinner dot --title "Restoring..." -- rsync -a --info=progress2 "$src" "$dest"
        
        if [ $? -eq 0 ]; then
            gum style --foreground 120 "✅ Restore successful!"
        else
            gum style --foreground 196 "❌ Restore failed."
        fi
    }

    # --- Main Logic ---

    MODE=$1
    ACTION=$2

    if [[ -z "$MODE" || -z "$ACTION" ]]; then
        echo "Usage: manageBackups local|online browse|restore|create|init"
        exit 1
    fi

    # ----------------- LOCAL (ZFS) -----------------
    if [[ "$MODE" == "local" ]]; then
        
        case "$ACTION" in
            browse|restore)
                # 1. List snapshots
                SNAP_BASE="$LOCAL_ROOT/$SNAPSHOT_DIR"
                
                if [ ! -d "$SNAP_BASE" ]; then
                    gum style --foreground 196 "Error: ZFS snapshot directory not found at $SNAP_BASE"
                    exit 1
                fi

                echo "Select a snapshot:"
                SELECTED_SNAP=$(ls -1 "$SNAP_BASE" | gum filter --height 10 --placeholder "Select snapshot...")

                if [[ -z "$SELECTED_SNAP" ]]; then exit 0; fi

                FULL_SNAP_PATH="$SNAP_BASE/$SELECTED_SNAP"

                # 2. Browse Content
                SELECTED_ITEM=$(gpick "$FULL_SNAP_PATH")
                
                if [[ -z "$SELECTED_ITEM" ]]; then exit 0; fi

                # 3. Action
                if [[ "$ACTION" == "browse" ]]; then
                    echo "You selected: $SELECTED_ITEM"
                    ls -lh "$SELECTED_ITEM"
                elif [[ "$ACTION" == "restore" ]]; then
                    # For ZFS local, the "base strip" is the full snapshot path
                    perform_restore "$SELECTED_ITEM" "$FULL_SNAP_PATH"
                fi
                ;;
            
            create)
                DEFAULT_NAME="manualSnapshot-$(date +%Y-%m-%d-%H%M)"
                SNAP_NAME=$(gum input --placeholder "$DEFAULT_NAME" --value "$DEFAULT_NAME" --header "Enter Snapshot Name")
                
                if [[ -z "$SNAP_NAME" ]]; then exit 1; fi

                gum spin --spinner line --title "Creating ZFS snapshot..." -- \
                    zfs snapshot "${zfsDataset}@$SNAP_NAME"

                if [ $? -eq 0 ]; then
                    gum style --foreground 120 "✅ Snapshot ${zfsDataset}@$SNAP_NAME created."
                else
                    gum style --foreground 196 "❌ Failed to create snapshot."
                fi
                ;;

            init)
                gum style --foreground 196 "❌ Init is not applicable for local ZFS mode."
                ;;
            *)
                echo "Unknown action for local: $ACTION"
                exit 1
                ;;
        esac

    # ----------------- ONLINE (RESTIC) -----------------
    elif [[ "$MODE" == "online" ]]; then

        case "$ACTION" in
            browse|restore)
                # 1. Ask for mount point
                MOUNT_POINT=$(gum input --placeholder "$DEFAULT_MOUNT" --value "$DEFAULT_MOUNT" --header "Mount Point")
                if [[ -z "$MOUNT_POINT" ]]; then exit 1; fi

                # 2. Check directory
                if [ -d "$MOUNT_POINT" ]; then
                    if [ -n "$(ls -A $MOUNT_POINT)" ]; then
                        if ! gum confirm "Directory $MOUNT_POINT is not empty. Proceed?"; then
                            exit 1
                        fi
                    fi
                else
                    mkdir -p "$MOUNT_POINT"
                fi

                # 3. Mount Restic (Background Process)
                gum style --foreground 212 "Mounting repository... (This may take a moment)"
                
                # We run it in background because it blocks
                $RESTIC_CMD mount --allow-other "$MOUNT_POINT" &
                RESTIC_PID=$!

                # Trap to ensure cleanup on exit or ctrl+c
                cleanup() {
                    echo ""
                    gum style --foreground 212 "Unmounting and cleaning up..."
                    kill $RESTIC_PID 2>/dev/null
                    fusermount -u "$MOUNT_POINT" 2>/dev/null
                    rmdir "$MOUNT_POINT" 2>/dev/null
                }
                trap cleanup EXIT INT TERM

                # Wait for mount to appear
                gum spin --spinner dot --title "Waiting for filesystem..." -- sleep 3

                SNAPSHOTS_DIR="$MOUNT_POINT/snapshots"
                
                # Verify mount success by checking if snapshots dir exists
                RETRIES=0
                while [ ! -d "$SNAPSHOTS_DIR" ]; do
                    sleep 1
                    RETRIES=$((RETRIES+1))
                    if [ $RETRIES -gt 10 ]; then
                        gum style --foreground 196 "❌ Mount timed out or failed."
                        exit 1
                    fi
                done

                # 4. Pick Snapshot
                # Restic mounts snapshots as directories named by their timestamp/ID in $MOUNT_POINT/snapshots
                SELECTED_SNAP=$(ls -1 "$SNAPSHOTS_DIR" | gum filter --height 10 --placeholder "Select Restic snapshot...")
                
                if [[ -z "$SELECTED_SNAP" ]]; then exit 0; fi # Cleanup will trigger via trap

                FULL_SNAP_PATH="$SNAPSHOTS_DIR/$SELECTED_SNAP"

                # 5. Browse Content
                SELECTED_ITEM=$(gpick "$FULL_SNAP_PATH")

                if [[ -z "$SELECTED_ITEM" ]]; then exit 0; fi

                # 6. Action
                if [[ "$ACTION" == "browse" ]]; then
                    echo "You selected: $SELECTED_ITEM"
                    ls -lh "$SELECTED_ITEM"
                    gum input --placeholder "Press Enter to finish and unmount..." 
                elif [[ "$ACTION" == "restore" ]]; then
                    # For Restic, the base strip is the specific snapshot path
                    perform_restore "$SELECTED_ITEM" "$FULL_SNAP_PATH"
                    
                    echo ""
                    gum input --placeholder "Press Enter to finish and unmount..." 
                fi
                ;;

            create)
                gum style --foreground 212 "Triggering systemd service: ${resticService}"
                gum spin --spinner line --title "Starting backup..." -- \
                    systemctl start "${resticService}"
                
                gum style --foreground 120 "✅ Backup service started (check 'systemctl status ${resticService}' for logs)."
                ;;

            init)
                gum style --border double --border-foreground 196 --foreground 196 \
                    "WARNING: This will initialize a NEW repository at ${resticRepo}."
                
                if gum confirm "Are you absolutely sure you haven't done this before?"; then
                    gum spin --spinner dot --title "Initializing..." -- \
                        $RESTIC_CMD init
                    
                    if [ $? -eq 0 ]; then
                        gum style --foreground 120 "✅ Repository initialized."
                    else
                        gum style --foreground 196 "❌ Init failed."
                    fi
                else
                    echo "Aborted."
                fi
                ;;
            *)
                echo "Unknown action for online: $ACTION"
                exit 1
                ;;
        esac

    else
        echo "Unknown mode: $MODE. Use 'local' or 'online'."
        exit 1
    fi
  '';

in [
      manageBackupsScript
    ];
    
    services.zfs.autoSnapshot = {
      enable = true;
      # specific datasets or the whole pool?
      # By default, it snapshots all datasets that have com.sun:auto-snapshot=true
      # generally good to keep default settings for retention (keep 4 15-mins, 24 hourly, etc.)
      flags = "-k -p";
    };

    sops.secrets."rclone_config" = {
      owner = "root"; # Restic runs as root usually
      sopsFile = ./syncSecrets.yaml;
      format = "yaml";
    };
    sops.secrets."restic_password" = {
      owner = "root";
      sopsFile = ./syncSecrets.yaml;
      format = "yaml";
    };

    services.restic.backups = {
      gdrive-backup = {
        # The user to run the backup as (usually root to access all files)
        user = "root";

        # Path to the file containing the repository password
        passwordFile = config.sops.secrets."restic_password".path;

        # The paths you want to backup
        paths = [ "/data" ];

        # Define the repository location using the rclone syntax:
        # rclone:<remote-name-in-conf>:<folder-path>
        repository = "rclone:gdrive:nixos-backup";

        # Configuration for rclone
        rcloneConfigFile = config.sops.secrets."rclone_config".path;

        # Schedule: When to run the backup (systemd calendar format)
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true; # Run immediately if missed while off
        };

        # Pruning: How long to keep old backups (This is the remote versioning)
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 4"
          "--keep-monthly 6"
        ];

        # Exclude patterns (optional)
        exclude = [
          ".zfs"        # IMPORTANT: Ignore the ZFS snapshot directory!
          "/data/tmp"
        ];
      };
    };
  };
}