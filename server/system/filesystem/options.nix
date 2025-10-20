{ config, lib, ... }:
{
  options.server.filesystem = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable custom filesystem configurations.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available filesystem configuration sets.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.server.filesystem.availableConfigs or [ ]);
      default = "default";
      description = "The active filesystem configuration set.";    
    };

    filesystemType = lib.mkOption {
      type = lib.types.str;
      description = "The type of filesystem to use. Is set by the active configuration.";
    };

    settings = {
      rootPath = lib.mkOption {
        type = lib.types.path;
        default = /srv;
        description = "The root path for the filesystem.";
      };

      shares = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            # This 'name' option is for the attribute key, e.g., "media" or "documents"
            # It will be used as the ZFS dataset name and mount point path component.
            name = lib.mkOption {
              type = lib.types.str;
              readOnly = true;
              internal = true; # This isn't user-facing
              description = "The internal ID of the share (from the attrset key).";
            };

            displayName = lib.mkOption {
              type = lib.types.str;
              description = "The network-visible name for the Samba share (e.g., 'Media').";
              # We can be clever and default to the capitalized 'name'
              default = lib.toTitle config.server.filesystem.settings.shares.${name}.name;
            };

            datapool = lib.mkOption {
              type = lib.types.str;
              description = "The name of the ZFS pool this dataset belongs to (e.g., 'datapool').";
            };

            browsable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether the share is visible in network browsing.";
            };

            readOnly = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether the share is read-only.";
            };

            guestsAllowed = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether guest users (without a password) are allowed access.";
            };

            users = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "List of NixOS users allowed to access this share (if guests are not allowed).";
            };
          };
        });
        default = { };
        description = "The set of declarative NAS shares to configure.";

        # This magic line sets the `name` option in the submodule
        # to be the key of the attribute set (e.g., "media").
        apply = lib.mapAttrs (name: def: def // { name = name; });
      };
    };

  };
}