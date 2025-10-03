{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.clock.enable && (config.packages.waybar.modules.clock.activeConfig == "default")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "clock" = {
        interval = 60;
        format = "{:%H:%M}";
        max-length = 25;
      };
    };
  };
}