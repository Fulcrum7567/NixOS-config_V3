{ config, lib, ... }:
{
  config = lib.mkIf config.theming.apps.waybar.enable {
    home-manager.users.${config.user.settings.username}.programs.waybar = {
      style = lib.concatStringsSep "\n" (
        builtins.map (item: item.content) (lib.sort (a: b: a.order < b.order) config.theming.apps.waybar.style)
      );
    };
  };
}