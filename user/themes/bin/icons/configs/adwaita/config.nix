{ lib, config, pkgs, settings, ... }:
{
    config = lib.mkIf (config.theming.icons.active == settings.optionName) {
    	environment.systemPackages = [
            settings.iconPackage
        ];

        theming.icons = {
            package = settings.iconPackage;
            name = settings.iconName;
        };
    };
}