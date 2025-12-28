{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.custom.wlogout.enable && (config.packages.waybar.modules.custom.wlogout.activeConfig == "custom1")) {
    packages.wlogout.enable = true;
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "custom/wlogout" = {
        format = "<span size='200%'>⏻</span>";
        on-click = "wlogout";
        tooltip-format = "⏻ Power Menu";
      };
    };
  };
}