{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, sops-nix, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		sops.secrets."networkSecrets.env" = {
			sopsFile = ../../../../../user/secrets/networkSecrets.env;
			format = "dotenv";
		};

		networking.networkmanager = {
			enable = true;

			ensureProfiles = {
				environmentFiles = [ config.sops.secrets."networkSecrets.env".path ];

				profiles = {
					"HUB" = {
						connection = {
							id = "HUB";
							type = "wifi";
						};
						wifi = {
							mode = "infrastructure";
							ssid = "$HUB_ssid";
						};
						wifi-security = {
							key-mgmt = "wpa-psk";
							psk = "$HUB_psk";
						};
					};

					"math" = {
						connection = {
							id = "math";
							type = "wifi";
						};
						wifi = {
							mode = "infrastructure";
							ssid = "$math_ssid";
						};
						wifi-security = {
							key-mgmt = "wpa-psk";
							psk = "$math_psk";
						};
					};

					"the view" = {
						connection = {
							id = "the view";
							type = "wifi";
						};
						wifi = {
							mode = "infrastructure";
							ssid = "$theView_ssid";
						};
						wifi-security = {
							key-mgmt = "wpa-psk";
							psk = "$theView_psk";
						};
					};

					"appletree" = {
						connection = {
							id = "appletree";
							type = "wifi";
						};
						wifi = {
							mode = "infrastructure";
							ssid = "$appletree_ssid";
						};
						wifi-security = {
							key-mgmt = "wpa-psk";
							psk = "$appletree_psk";
						};
					};

					"ocean" = {
						connection = {
							id = "ocean";
							type = "wifi";
						};
						wifi = {
							mode = "infrastructure";
							ssid = "$ocean_ssid";
						};
						wifi-security = {
							key-mgmt = "wpa-psk";
							psk = "$ocean_psk";
						};
					};

					"std" = {
						connection = {
							id = "std";
							type = "wifi";
						};
						wifi = {
							mode = "infrastructure";
							ssid = "$std_ssid";
						};
						wifi-security = {
							key-mgmt = "wpa-eap";
							eap = "ttls";
							identity = "$std_identity";
							password = "$std_password";
							phase2 = "auth=MSCHAPV2";
						};
					};

					"nova" = {
						connection = {
							id = "nova";
							type = "wifi";
						};
						wifi = {
							mode = "infrastructure";
							ssid = "$nova_ssid";
						};
						wifi-security = {
							key-mgmt = "wpa-psk";
							psk = "$nova_psk";
						};
					};

					"thick" = {
						connection = {
							id = "thick";
							type = "wifi";
						};
						wifi = {
							mode = "infrastructure";
							ssid = "$thick_ssid";
						};
						wifi-security = {
							key-mgmt = "wpa-psk";
							psk = "$thick_psk";
						};
					};
				};
			};
		};
		
		/*
		networking = {
			networkmanager.enable = config.desktopEnvironments.gnome.gnomeBase.enable;
			wireless = lib.mkIf (!config.desktopEnvironments.gnome.gnomeBase.enable) {
				enable = true;
				userControlled = true;

				networks = {
					"Obi Wlan Kenobi 5 GHz" = {
						pskRaw = "215f719017acab610345cdf770e8708ce16880f14121746e9e980d0d495e4717";
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

					"Stoetzels FRITZ!Box 7490" = {
						pskRaw = "e436390a5a2b19e0e92d6663b9af576eff2d843a0248c951a4afa3368973ca82";
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
		*/
		

	};
} 
