{ config, lib, pkgs-default, ... }:
{
  config = lib.mkIf (config.server.services.autoBackup.enable && (config.server.services.autoBackup.activeConfig == "default")) {
    
    environment.systemPackages = let
        gum = pkgs-default.gum;
        rclone = pkgs-default.rclone;
        restic = pkgs-default.restic;
        
        # Accessing secrets (assuming sops-nix usage based on prompt)
        rcloneConfig = config.sops.secrets."rclone_config".path;
        resticPassword = config.sops.secrets."restic_password".path;
      in [
      (pkgs-default.writeShellScriptBin "manageBackups" ''
        if [ "$EUID" -ne 0 ]; then
          exec sudo "$0" "$@"
        fi

        # --- Configuration & Environment Variables ---
        export PATH="${rclone}/bin:${gum}/bin:${restic}/bin:${pkgs-default.coreutils}/bin:${pkgs-default.gnugrep}/bin:${pkgs-default.util-linux}/bin:${pkgs-default.systemd}/bin:$PATH"
        
        export RCLONE_CONFIG="${rcloneConfig}"
        REPO="rclone:gdrive:nixos-backup"
        PASSWORD_FILE="${resticPassword}"
        
        # Helper to run Restic with standard flags
        RESTIC_CMD() {
          nohup restic -r "$REPO" --password-file ${config.sops.secrets."restic_password".path} "$@" > /dev/null 2>&1
        }

        # --- UI Helpers ---
        header() {
          gum style --foreground 212 --border-foreground 212 --border double --align center --width 50 --margin "1 2" --padding "2 4" "$1"
        }

        confirm() {
          gum confirm "$1" || exit 1
        }

        # --- Local Operations (ZFS) ---

        local_browse() {
          header "Local ZFS: Browse"
          
          gum style --foreground 240 "Loading snapshots..."
          SNAPSHOT_DIR="/data/.zfs/snapshot"
          
          # 1. List and Select Snapshot
          SNAPSHOT=$(ls -1 "$SNAPSHOT_DIR" | gum filter --height 20 --placeholder "Select a snapshot to browse...")
          
          if [ -z "$SNAPSHOT" ]; then echo "No snapshot selected."; exit 1; fi
          
          # 2. Browse Content
          gum style --foreground 39 "Browsing $SNAPSHOT... (Press Esc to exit)"
          gum file "$SNAPSHOT_DIR/$SNAPSHOT" --height 20
        }

        local_restore() {
          header "Local ZFS: Restore"
          
          SNAPSHOT_DIR="/data/.zfs/snapshot"
          
          # 1. List and Select Snapshot
          SNAPSHOT=$(ls -1 "$SNAPSHOT_DIR" | gum filter --height 20 --placeholder "Select a snapshot to restore from...")
          if [ -z "$SNAPSHOT" ]; then exit 1; fi
          
          # 2. Select File/Folder
          gum style --foreground 39 "Select the file or folder to restore:"
          TARGET=$(gum file "$SNAPSHOT_DIR/$SNAPSHOT" --height 20 --file --directory)
          
          if [ -z "$TARGET" ]; then echo "No selection made."; exit 1; fi

          # 3. Calculate Destination
          # Logic: Remove the snapshot prefix (/data/.zfs/snapshot/SNAPNAME) to get the relative path inside /data
          REL_PATH="''${TARGET#$SNAPSHOT_DIR/$SNAPSHOT/}"
          DEST="/data/$REL_PATH"

          gum style --foreground 212 "Source: $TARGET"
          gum style --foreground 212 "Dest:   $DEST"

          if [ -e "$DEST" ]; then
            gum confirm "Destination exists. Overwrite?" || exit 0
          fi

          # 4. Copy
          gum spin --title "Restoring..." -- cp -r "$TARGET" "$DEST"
          gum style --foreground 76 "Restore complete!"
        }

        local_create() {
          header "Local ZFS: Create Snapshot"
          
          DEFAULT_NAME="manualSnapshot-$(date +%Y-%m-%d-%H%M%S)"
          NAME=$(gum input --value "$DEFAULT_NAME" --placeholder "Enter snapshot name")

          if [ -z "$NAME" ]; then echo "Operation cancelled."; exit 1; fi

          if gum spin --title "Creating snapshot..." -- sudo zfs snapshot "zroot/root/data@$NAME"; then
              gum style --foreground 76 "Snapshot zroot/root/data@$NAME created successfully."
          else
              gum style --foreground 196 "Failed to create snapshot."
              exit 1
          fi
        }

        # --- Online Operations (Restic) ---

        online_mount_and_act() {
          ACT_TYPE=$1 # "browse" or "restore"

          header "Online Backup: $ACT_TYPE"

          # 1. Mount Point
          MOUNT_POINT=$(gum input --value "/mnt/restoreTemp" --placeholder "Mount point")
          
          # 2. Check/Create Directory
          if [ ! -d "$MOUNT_POINT" ]; then
              gum spin --title "Creating directory..." -- mkdir -p "$MOUNT_POINT"
          else
              if [ "$(ls -A $MOUNT_POINT)" ]; then
                  confirm "Directory $MOUNT_POINT is not empty. Continue?" 
              fi
          fi

          # 3. Mount Restic (Background)
          echo "Mounting repository..."
          
          # We run restic in the background. 
          # Restic blocks, so we need to capture PID to kill it later.
          RESTIC_CMD mount --allow-other "$MOUNT_POINT" &
          RESTIC_PID=$!
          export RESTIC_PID MOUNT_POINT
          
          # Wait for mount to be ready
          gum spin --title "Waiting for mount..." -- bash -c '
            count=0
            while [ ! -d "$MOUNT_POINT/snapshots" ]; do
              if ! kill -0 "$RESTIC_PID" 2>/dev/null; then exit 1; fi
              sleep 1
              count=$((count+1))
              if [ "$count" -ge 600 ]; then exit 1; fi
            done
          '
          
          # Trap cleanup to ensure unmount happens on exit/Ctrl+C
          cleanup() {
              echo ""
              gum style --foreground 240 "Unmounting and cleaning up..."
              kill $RESTIC_PID 2>/dev/null
              wait $RESTIC_PID 2>/dev/null
              
              # Using fusermount for cleaner unmount as user/root
              #fusermount -u "$MOUNT_POINT" 2>/dev/null || umount "$MOUNT_POINT" 2>/dev/null
              
              # Remove dir if we created it (optional, safe to leave if empty)
              #rmdir "$MOUNT_POINT" 2>/dev/null
          }
          trap cleanup EXIT INT TERM

          # 4. Pick Snapshot
          SNAPSHOT_ROOT="$MOUNT_POINT/snapshots"
          
          # Check if mount succeeded by looking for snapshots dir
          if [ ! -d "$SNAPSHOT_ROOT" ]; then
              gum style --foreground 196 "Failed to access snapshots. Check your Restic password/config."
              exit 1
          fi

          SELECTED_SNAP=$(ls -1 "$SNAPSHOT_ROOT" | gum filter --height 20 --placeholder "Select a snapshot ID")
          if [ -z "$SELECTED_SNAP" ]; then exit 0; fi

          SNAP_PATH="$SNAPSHOT_ROOT/$SELECTED_SNAP"

          if [ "$ACT_TYPE" == "browse" ]; then
              gum style --foreground 39 "Browsing snapshot $SELECTED_SNAP..."
              gum file "$SNAP_PATH" --height 20
          
          elif [ "$ACT_TYPE" == "restore" ]; then
              gum style --foreground 39 "Select item to restore:"
              TARGET=$(gum file "$SNAP_PATH" --height 20 --file --directory)
              
              if [ -n "$TARGET" ]; then
                  # Attempt to map path back to /data
                  # Restic structure usually: /mnt/.../snapshots/ID/data/foo or /mnt/.../snapshots/ID/foo
                  # We assume the user wants to restore to /data.
                  
                  # Simple logic: Ask user for destination, defaulting to /data/FILENAME
                  BASENAME=$(basename "$TARGET")
                  DEST_DEFAULT="/data/$BASENAME"
                  
                  DEST=$(gum input --value "$DEST_DEFAULT" --placeholder "Restore destination path")
                  
                  if [ -e "$DEST" ]; then
                      confirm "Destination $DEST exists. Overwrite?"
                  fi

                  gum spin --title "Restoring files..." -- cp -r "$TARGET" "$DEST"
                  gum style --foreground 76 "Restored to $DEST"
              fi
          fi
          
          # Cleanup happens via trap automatically
      }

      online_create() {
          header "Online Backup: Create"
          gum spin --title "Starting systemd service..." -- sudo systemctl start restic-backups-gdrive-backup
          
          # Check status briefly
          if systemctl is-active --quiet restic-backups-gdrive-backup; then
              gum style --foreground 76 "Backup service started successfully."
          else
              gum style --foreground 240 "Service triggered (oneshot)."
          fi
      }

      online_init() {
          header "Online Backup: Initialize"
          gum style --foreground 196 "WARNING: This will initialize a new Restic repository at $REPO"
          confirm "Are you absolutely sure you haven't done this before?"
          
          if gum spin --title "Initializing..." -- RESTIC_CMD init; then
              gum style --foreground 76 "Repository initialized successfully."
          else
              gum style --foreground 196 "Initialization failed."
          fi
      }

      # --- Main Dispatch ---

      MODE=$1
      ACTION=$2

      if [[ -z "$MODE" || -z "$ACTION" ]]; then
          echo "Usage: manageBackups local|online browse|restore|create|init"
          exit 1
      fi

      case "$MODE" in
          local)
              case "$ACTION" in
                  browse)  local_browse ;;
                  restore) local_restore ;;
                  create)  local_create ;;
                  init)    echo "Init not available for local mode."; exit 1 ;;
                  *)       echo "Unknown action: $ACTION"; exit 1 ;;
              esac
              ;;
          online)
              case "$ACTION" in
                  browse)  online_mount_and_act "browse" ;;
                  restore) online_mount_and_act "restore" ;;
                  create)  online_create ;;
                  init)    online_init ;;
                  *)       echo "Unknown action: $ACTION"; exit 1 ;;
              esac
              ;;
          *)
              echo "Unknown mode: $MODE (use local or online)"
              exit 1
              ;;
      esac
      '')
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