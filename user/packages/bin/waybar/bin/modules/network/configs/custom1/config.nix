{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.network.enable && (config.packages.waybar.modules.network.activeConfig == "custom1")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "network" = {
        # on-click = "nm-connection-editor";
        # "interface" = "wlp2*"; # (Optional) To force the use of this interface
        format-wifi = "󰤨";
        # format-wifi = " {bandwidthDownBits}  {bandwidthUpBits}";
        # format-wifi = "󰤨 {essid}";
        format-ethernet = "󱘖";
        # format-ethernet = " {bandwidthDownBits}  {bandwidthUpBits}";
        # format-linked = "󰤪 Secure";
        # format-linked = "󱘖 {ifname} (No IP)";
        format-disconnected = "󰤮 Off";
        # format-disconnected = "󰤮 Disconnected";
        tooltip-format = "{essid} - {signalStrength}%\n 󱘖 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
      };
    };
  };
}