{ config, lib, ... }:
{
  config = lib.mkIf config.packages.hyprpaper.enable {
    
    home-manager.users.${config.user.settings.username}.services.hyprpaper.settings = {

      preload = if config.theming.wallpaper.type == "single" then [ "${config.theming.wallpaper.wallpaperPath}/${config.theming.wallpaper.single.active}" ]
                  else ( if config.theming.wallpaper.type == "diashow" then (
                    builtins.map (name: "${config.theming.wallpaper.wallpaperPath}/${name}") config.theming.wallpaper.diashow.active.wallpapers
                  ) else [] );
      wallpaper = if config.theming.wallpaper.type == "single" then [ ",${config.theming.wallpaper.wallpaperPath}/${config.theming.wallpaper.single.active}" ]
                  else [];
    };

    theming.wallpaper.diashow = {
      selectCommand = "hyprctl hyprpaper reload ,'<wallpaperPath>'";
      additionalPackages = [ config.programs.hyprland.package ];
    };

  };
}