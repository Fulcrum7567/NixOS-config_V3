{ config, lib, ... }:
{
  options.hardware = {

    displays = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable configuration for this display.";
          };

          name = lib.mkOption {
            type = lib.types.str;
            description = "Name of the display (e.g., 'HDMI-A-1').";
          };

          primary = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Set this display as the primary display.";
          };

          resolution = lib.mkOption {
            type = lib.types.str;
            default = "1920x1080";
            description = "Set the resolution for this display.";
          };

          position = lib.mkOption {
            type = lib.types.str;
            default = "0x0";
            description = "Set the position for this display (e.g., '1920x0' for right of a 1920x1080 primary).";
          };

          refreshRate = lib.mkOption {
            type = lib.types.int;
            default = 60;
            description = "Set the refresh rate for this display.";
          };
        };
      });
      description = "Configuration options for connected displays.";
    };
  };
}