{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, currentHost, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "PET")) {

		sops.secrets = {
			"syncthing/devices/PET/key" = { 
				owner = config.services.syncthing.user;
				group = config.services.syncthing.group;
				# Point to the specific file
				sopsFile = ../../bin/syncthingSecrets.yaml;
				format = "yaml";
				key = "devices/PET/key";
				restartUnits = [ "syncthing.service" ];
			};

			"syncthing/devices/PET/cert" = { 
				owner = config.services.syncthing.user;
				group = config.services.syncthing.group;
				format = "yaml";
				sopsFile = ../../bin/syncthingSecrets.yaml;
				restartUnits = [ "syncthing.service" ];
				key = "devices/PET/cert";
			};			
		};

		warnings = (if (currentHost != "PET") then [
			"You are using the PET configuration on a host that is not 'PET'. Please ensure this is intentional."
		] else []);

		services.syncthing = {

			key = config.sops.secrets."syncthing/devices/PET/key".path;
			cert = config.sops.secrets."syncthing/devices/PET/cert".path;

			settings = {
				folders = {
					"FH" = {
						path = "/home/${config.user.settings.username}/Documents/FH";
						devices = [ "Server" ];
						ignorePatterns = config.packages.${settings.optionName}.commonIgnores;
					};
				};
			};

		};
	};
} 
