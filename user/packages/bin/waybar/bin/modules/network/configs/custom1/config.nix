{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.network.enable && (config.packages.waybar.modules.network.activeConfig == "custom1")) {

    packages.nmgui.enable = true;

    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "network" = {
        # on-click = "nm-connection-editor";
        # "interface" = "wlp2*"; # (Optional) To force the use of this interface
        on-click = "nmgui";
        on-click-middle = "if [[ $(nmcli n connectivity) == \"limited\" ]]; then nmcli r all on; else nmcli r all off; fi";
        interval = 10;
        format = "<span size='250%'></span>";
        format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        format-wifi = "<span size='250%'>{icon}</span>";
        format-ethernet = "<span size='150%'>󰈁</span>";
        format-disconnected = "<span size='250%'>󰤮</span>";
        format-disabled = "<span size='250%'>󰤮</span> <span rise='7800'>Off</span>";
        tooltip-format = "󰈁 {essid}\n 󰩠 {ipaddr}  {bandwidthUpBits}  {bandwidthDownBits}";
        tooltip-format-wifi = "{icon} {essid} ({frequency} GHz) - {signalStrength}%\n󰩠 {ipaddr}  {bandwidthUpBits}  {bandwidthDownBits}";
        tooltip-format-disconnected = "󰤮 Disconnected";
        tooltip-format-disabled = "󰤮 Network Disabled";
        
      };
    };
  };
}