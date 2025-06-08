{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.fixes.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {
				"org/blueman/general" = {
					plugin-list = [ "!ShowConnected" "!StatusIcon" ];
				};
			};
		};

		hardware.bluetooth = {
		    enable = true;
		    powerOnBoot = true;
		    settings.General = {
		      experimental = true; # show battery

		      # https://www.reddit.com/r/NixOS/comments/1ch5d2p/comment/lkbabax/
		      # for pairing bluetooth controller
		      Privacy = "device";
		      JustWorksRepairing = "always";
		      Class = "0x000100";
		      FastConnectable = true;
		    };
	  	};

	  	services.blueman.enable = true;

	  	hardware.xpadneo.enable = true; # Enable the xpadneo driver for Xbox One wireless controllers

		  boot = {
		    extraModulePackages = [ 
		    	config.boot.kernelPackages.xpadneo
		    	#pkgs.linuxPackages.nvidia_x11
			  	#pkgs.linuxPackages.kernel
		     ];
		    extraModprobeConfig = ''
		      options bluetooth disable_ertm=Y
		    '';
		    # connect xbox controller
		  };

	};
} 
