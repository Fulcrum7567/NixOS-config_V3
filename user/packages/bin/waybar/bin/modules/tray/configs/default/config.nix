{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.tray.enable && (config.packages.waybar.modules.tray.activeConfig == "default")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      tray = {
        icon-size = 21;
        spacing = 10;
        icons = {
          blueman = "bluetooth";
          # TelegramDesktop = "$HOME/.local/share/icons/hicolor/16x16/apps/telegram.png";
        };
      };
    };
  };
}