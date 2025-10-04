{ config, lib, ... }:
{
  options.theming.apps.waybar = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.enable;
      description = "Enable waybar theme module.";
    };

    style = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          order = lib.mkOption {
            type = lib.types.int;
            default = 500;
            description = "Order in which the style is added to the final file (lower numbers are added first).";
          };
          content = lib.mkOption {
            type = lib.types.str;
            description = "CSS content to be applied to waybar.";
          };
        };
      });
      default = [ ];
      description = "Custom CSS styles to apply to waybar.";
    };
  };
}