{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.bluetooth.enable && (config.packages.waybar.modules.bluetooth.activeConfig == "custom1")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "bluetooth" = {
        
        format-disabled = ""; # an empty format will hide the module when the module is disabled
        format-off = "<span size='150%'>󰂲</span>";
        format-on = "<span size='150%'></span>";
        format-no-controller = "";
        format-connected = "<span size='150%'>󰂱</span> <span rise='3000'>{num_connections}</span>";
        tooltip-format-off = "󰂲 Bluetooth is disabled";
        tooltip-format-on = " Bluetooth is enabled";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-enumerate-connected = " {device_alias}";
        tooltip-format-connected-battery = "{device_enumerate}";
        tooltip-format-enumerate-connected-battery = " {device_alias} ({device_battery_percentage}% 󰥉)";
        on-click = "blueman-manager";
        
      };
    };
  };
}