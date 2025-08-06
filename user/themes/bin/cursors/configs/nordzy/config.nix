{ lib, config, pkgs, settings, ... }:
{
    config = lib.mkIf (config.theming.cursors.active == settings.optionName) {
    	environment.systemPackages = [
            settings.cursorPackage
        ];

        theming.cursors = {
            package = settings.cursorPackage;
            name = settings.cursorName;
        };
    };
}