{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.network.enable && (config.packages.waybar.modules.network.activeConfig == "default")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      network = {
        interface = "wlp2s0";
        format = "{ifname}";
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "{ipaddr}/{cidr} 󰊗";
        format-disconnected = ""; # An empty format will hide the module.
        tooltip-format = "{ifname} via {gwaddr} 󰊗";
        tooltip-format-wifi = "{essid} ({signalStrength}%) ";
        tooltip-format-ethernet = "{ifname} ";
        tooltip-format-disconnected = "Disconnected";
        max-length = 50;
      };
    };
  };
}