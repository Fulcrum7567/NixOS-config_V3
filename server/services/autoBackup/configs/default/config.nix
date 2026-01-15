{ config, lib, ... }:
{
  config = lib.mkIf (config.server.services.autoBackup.enable && (config.server.services.autoBackup.activeConfig == "default")) {
    
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