{ config, lib, pkgs, ... }:
let 
  custom-sddm-theme = pkgs.sddm-astronaut.override {
    embeddedTheme = "hyprland_kath";
  };
in 
{
  config = lib.mkIf (config.theming.apps.sddm.enable && (config.theming.apps.sddm.activeConfig == "default")) {

    environment.systemPackages = with pkgs; [
       custom-sddm-theme
    ];

    services.displayManager.sddm = {
      extraPackages = with pkgs; [
        custom-sddm-theme
      ];

      theme = "sddm-astronaut-theme";
      settings = {
        Theme = {
          Current = "sddm-astronaut-theme";
        };
      };
    };
    
  };
}