{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.network.enable && (config.packages.waybar.modules.network.activeConfig == "slyHarvey")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "network" = {
        # on-click = "nm-connection-editor";
        # "interface" = "wlp2*"; # (Optional) To force the use of this interface
        format-wifi = "󰤨 Wi-Fi";
        # format-wifi = " {bandwidthDownBits}  {bandwidthUpBits}";
        # format-wifi = "󰤨 {essid}";
        format-ethernet = "󱘖 Wired";
        # format-ethernet = " {bandwidthDownBits}  {bandwidthUpBits}";
        format-linked = "󰤪 Secure";
        # format-linked = "󱘖 {ifname} (No IP)";
        format-disconnected = "󰤮 Off";
        # format-disconnected = "󰤮 Disconnected";
        format-alt = "󰤨 {signalStrength}%";
        tooltip-format = "󱘖 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
      };
    };
  };
}