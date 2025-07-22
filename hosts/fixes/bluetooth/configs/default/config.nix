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

		services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
			"monitor.bluez.properties" = {
				"bluez5.enable-sbc-xq" = true;
				"bluez5.enable-msbc" = true;
				"bluez5.enable-hw-volume" = true;
				"bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
			};
		};

	    services.pulseaudio.enable = false;
	    security.rtkit.enable = true;
	    services.pipewire = {
	        enable = true;
	        alsa.enable = true;
	        alsa.support32Bit = true;
	        pulse.enable = true;
	        wireplumber.configPackages = [
	          (pkgs-default.writeTextDir "share/wireplumber/wireplumber.conf.d/10-bluez.conf" ''
	            monitor.bluez.properties = {
					bluez5.roles = [ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]
					bluez5.codecs = [ sbc sbc_xq aac ]
					bluez5.enable-sbc-xq = true
					bluez5.hfphsp-backend = "native"
	            }
	          '')
	        ];
	    };

		boot.kernelModules = [ "btusb" ];

		hardware.bluetooth = {
		    enable = true;
		    powerOnBoot = true;
		    package = pkgs-default.bluez;
		    settings.General = {
		    	ControllerMode = "dual";
				Experimental = true; # show battery
				KernelExperimental = true;

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
