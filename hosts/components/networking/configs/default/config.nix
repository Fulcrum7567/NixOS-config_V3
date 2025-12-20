{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		
		networking = {
			networkmanager.enable = config.desktopEnvironments.gnome.gnomeBase.enable;
			wireless = {
				enable = !config.desktopEnvironments.gnome.gnomeBase.enable;

				networks = {
					"Obi Wlan Kenobi 5GHz" = {
						pskRaw = "dc17a708c048642dfce8e96376d476b9001c11956567990af0cd522b58d1754c";
					};

					"FRITZ!Box 7490" = {
						pskRaw = "54fa802e4e2cce3ba8cd0e3b0f1ce42a83797dc92c8f7a980c476ee6883c2bdd";
					};

					"FRITZ!Box 7510 JB" = {
						pskRaw = "30b94206fc3c13e62221a0c99eda0ce7528636acbcffff255ed2d89c02d1cc43";
					};

					"Mario's S23" = {
						pskRaw = "1cbafa8a27a779a8875cc9cec0cecc24ddb7528680dd0f5237093e7bb64188ac";
					};

					"Apfelsaft" = {
						pskRaw = "1bc394df3c25a7d6034b35ed2e3fc4cdeacbf79343e8e986c9260d20467fa7b8";
					};

					"FH-AD-Student" = {
						auth = ''
							key_mgmt=WPA-EAP
							eap=TTLS
							phase2="auth=MSCHAPV2"
							identity="stud106256"
							password=hash:a39df15efb7435412c24a035e33c2563
						'';
					};
				};

			};

		};
		

	};
} 
