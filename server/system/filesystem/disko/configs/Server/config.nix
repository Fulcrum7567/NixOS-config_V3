{ config, lib, disko, ... }:
{
  config = lib.mkIf (config.server.system.filesystem.disko.enable) {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/disk/by-id/${config.server.system.filesystem.disko.diskId}";

          content = {
            type = "gpt";

            partitions = {
              ESP = {
                size = "2G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };

              swap = {
                size = "8G";
                content = {
                  type = "swap";
                  discardPolicy = "both";
                };
              };

              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "zroot";
                };
              };
            };
          };
        };
      };

      zpool = {
        zroot = {
          type = "zpool";
          mode = "";
          options = {
            ashift = 12;
            autotrim = "on";
          };

          rootFsOptions = {
            compression = "lz4";
            acltype = "posixacl";
            xattr = "sa";
            "com.sun:auto-snapshot" = "false";
          };

          datasets = {
            "root" = {
              type = "zfs_fs";
              options = {
                mountpoint = "none";
                reservation = "1G";
              };
            };

            "root/nixos" = {
              type = "zfs_fs";
              mountpoint = "/";
              options.mountpoint = "legacy";
            };

            "root/nix" = {
              type = "zfs_fs";
              mountpoint = "/nix";
              options = {
                mountpoint = "legacy";
                atime = "off";
              };
            };

            "root/home" = {
              type = "zfs_fs";
              mountpoint = "/home";
              options = {
                mountpoint = "legacy";
                "com.sun:auto-snapshot" = "true";
              };
            };
          };
        };
      };
    };
  };
}