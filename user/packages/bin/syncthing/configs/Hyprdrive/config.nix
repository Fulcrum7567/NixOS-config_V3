{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, currentHost, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "Hyprdrive")) {

		sops.secrets = {
			"syncthing/devices/Hyprdrive/key" = { 
				owner = "syncthing";
				group = "syncthing";
				# Point to the specific file
				sopsFile = ../../bin/syncthingSecrets.yaml;
				format = "yaml";
				key = "devices/Hyprdrive/key";
				restartUnits = [ "syncthing.service" ];
			};

			"syncthing/devices/Hyprdrive/cert" = { 
				owner = "syncthing";
				group = "syncthing";
				format = "yaml";
				sopsFile = ../../bin/syncthingSecrets.yaml;
				restartUnits = [ "syncthing.service" ];
				key = "devices/Hyprdrive/cert";
			};			
		};

		warnings = (if (currentHost != "Hyprdrive") then [
			"You are using the Hyprdrive configuration on a host that is not 'Hyprdrive'. Please ensure this is intentional."
		] else []);

		services.syncthing = {

			key = config.sops.secrets."syncthing/devices/Hyprdrive/key".path;
			cert = config.sops.secrets."syncthing/devices/Hyprdrive/cert".path;

			settings = {
				folders = {
					"FH" = {
						path = "/home/${config.user.settings.username}/Documents/FH";
						devices = [ "Server" ];
					};
				};
			};

		};
	};
} 
