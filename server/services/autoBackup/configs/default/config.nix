{ config, lib, pkgs-default, ... }:
{
  config = lib.mkIf (config.server.services.autoBackup.enable && (config.server.services.autoBackup.activeConfig == "default")) {
    
    environment.systemPackages = [
      # run gdrive-backup init ONLY ONCE FOR EVERY NEW REPO!!
      (pkgs-default.writeShellScriptBin "gdrive-backup" ''
        # Use sudo automatically if not running as root
        if [ "$EUID" -ne 0 ]; then
          exec sudo "$0" "$@"
        fi

        export RCLONE_CONFIG=${config.sops.secrets."rclone_config".path}
        export PATH=${pkgs-default.rclone}/bin:$PATH

        RESTIC="${pkgs-default.restic}/bin/restic"
        REPO="rclone:gdrive:nixos-backup"
        PASSWORD_FILE="${config.sops.secrets."restic_password".path}"
        TEMP_MOUNT_PATH="/mnt/restore_temp/"

        COMMAND="$1"

        if [ "$COMMAND" = "browse" ]; then
          shift
          while [ "$#" -gt 0 ]; do
            case "$1" in
              -tm|--temp_mount_path) TEMP_MOUNT_PATH="$2"; shift 2;;
              *) echo "Unknown option: $1"; exit 1;;
            esac
          done

          if [ -d "$TEMP_MOUNT_PATH" ] && [ "$(ls -A "$TEMP_MOUNT_PATH")" ]; then
            echo "Directory $TEMP_MOUNT_PATH is not empty."
            read -p "Do you want to change the temp_mount_path (c) or overwrite/mount over it (o)? [c/O] " CHOICE
            if [ "$CHOICE" = "c" ] || [ "$CHOICE" = "C" ]; then
              read -p "Enter new path: " TEMP_MOUNT_PATH
            fi
          fi

          mkdir -p "$TEMP_MOUNT_PATH"
          echo "Mounting..."
          nohup $RESTIC -r "$REPO" --password-file "$PASSWORD_FILE" mount --allow-other "$TEMP_MOUNT_PATH" > /dev/null 2>&1 &
          MOUNT_PID=$!

          echo "Waiting for mount to be ready..."
          COUNT=0
          while [ ! -d "$TEMP_MOUNT_PATH/snapshots" ]; do
            sleep 1
            COUNT=$((COUNT+1))
            if [ "$COUNT" -ge 60 ]; then
              echo "Timed out waiting for mount."
              exit 1
            fi
            if ! kill -0 $MOUNT_PID 2>/dev/null; then
              echo "Mount process failed to start."
              exit 1
            fi
          done

          echo "Mount established."
          echo "Available versions:"
          ls "$TEMP_MOUNT_PATH/snapshots"

          read -p "Select a version to browse [latest]: " VERSION
          VERSION="''${VERSION:-latest}"

          BROWSE_PATH="$TEMP_MOUNT_PATH/snapshots/$VERSION"
          if [ -d "$BROWSE_PATH" ]; then
            echo "Starting shell ($SHELL) in $BROWSE_PATH"
            (cd "$BROWSE_PATH" && exec "$SHELL")
          else
            echo "Version $VERSION not found."
          fi

        elif [ "$COMMAND" = "init" ]; then
          echo "Are you sure you have NEVER done this before for this REPO?"
          read -p "Confirm [y/N]: " CONFIRM
          if [ "$CONFIRM" = "y" ] || [ "$CONFIRM" = "Y" ]; then
            exec $RESTIC -r "$REPO" --password-file "$PASSWORD_FILE" init
          fi

        else
          exec $RESTIC -r "$REPO" --password-file "$PASSWORD_FILE" "$@"
        fi
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