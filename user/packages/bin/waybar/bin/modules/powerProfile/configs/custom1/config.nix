{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.powerProfile.enable && (config.packages.waybar.modules.powerProfile.activeConfig == "custom1")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      power-profiles-daemon = {
        format = "{icon}";
        tooltip-format = "Power profile: {profile}\nDriver: {driver}";
        tooltip = true;
        format-icons = {
          default = "<span size='150%'></span>";
          performance = "<span size='150%'></span>";
          balanced = "<span size='250%'></span>";
          power-saver = "<span size='225%'></span>";
        };
      };
    };
  };
}