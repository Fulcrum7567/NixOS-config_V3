{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "prism")) {
		environment.systemPackages = with pkgs-default; [
			(prismlauncher.override {
	    		# Add binary required by some mod
	    		additionalPrograms = [ ffmpeg ];
	    	})
		];
	};
} 
