{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.powerProfile.enable && (config.packages.waybar.modules.powerProfile.activeConfig == "custom1")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      power-profiles-daemon = {
        format = "<span size='150%'>{icon}</span>";
        tooltip-format = "Power profile: {profile}\nDriver: {driver}";
        tooltip = true;
        format-icons = {
          default = "";
          performance = "";
          balanced = "";
          power-saver = "";
        };
      };
    };
  };
}