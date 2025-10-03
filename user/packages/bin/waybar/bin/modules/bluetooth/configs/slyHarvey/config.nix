{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.bluetooth.enable && (config.packages.waybar.modules.bluetooth.activeConfig == "slyHarvey")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "bluetooth" = {
        format = "";
        # format-disabled = ""; # an empty format will hide the module
        format-connected = " {num_connections}";
        tooltip-format = " {device_alias}";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-enumerate-connected = " {device_alias}";
        on-click = "blueman-manager";
      };
    };
  };
}