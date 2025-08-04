{ lib, config, pkgs, settings, ... }:
{
    config = {
    	fonts = lib.mkIf config.theming.fonts.${settings.optionName}.active {
    		packages = [
    			settings.fontPackage
    		];
    	};

    	theming.fonts = {
    		monospace = lib.mkIf (config.theming.fonts.monospace.config == settings.optionName) {
    			package = settings.fontPackage;
    			name = settings.fontName;
    		};

    		sansSerif = lib.mkIf (config.theming.fonts.sansSerif.config == settings.optionName) {
    			package = settings.fontPackage;
    			name = settings.fontName;
    		};

    		serif = lib.mkIf (config.theming.fonts.serif.config == settings.optionName) {
    			package = settings.fontPackage;
    			name = settings.fontName;
    		};

    	};
    };
}