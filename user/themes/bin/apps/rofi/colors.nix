{ config, lib, ... }:
{
  config = lib.mkIf (config.theming.apps.rofi.enable) {

    # 1. Define the NixOS option in the NixOS scope
    theming.apps.rofi.starConfig = let
      # "Polyfill" mkLiteral locally so we don't need HM's config.lib
      # This is exactly what the HM function does internally.
      mkLiteral = value: {
        _type = "literal";
        inherit value;
      };
      
      # Use 'config' (which is the system config here) to access colors
      colors = config.colorScheme.palette;
    in [
      {
        background = lib.mkForce (mkLiteral "#${colors.base00}FF");
        background-alt = lib.mkForce (mkLiteral "#${colors.base01}FF");
        foreground = lib.mkForce (mkLiteral "#${colors.base05}FF");
        selected = lib.mkForce (mkLiteral "#${colors.base0D}FF");
        active = lib.mkForce (mkLiteral "#${colors.base0B}FF");
        urgent = lib.mkForce (mkLiteral "#${colors.base08}FF");
      }
    ];
  };
}