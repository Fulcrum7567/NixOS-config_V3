{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, currentHost, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "PET")) {

		sops.secrets = {
			"syncthing-PET-key" = { 
				owner = "syncthing";
				group = "syncthing";
				# Point to the specific file
				sopsFile = ../../bin/syncthingSecrets.yaml;
				format = "yaml";
				key = "devices/PET/key";
				restartUnits = [ "syncthing.service" ];
			};

			"syncthing-PET-cert" = { 
				owner = "syncthing";
				group = "syncthing";
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

			key = config.sops.secrets."syncthing-PET-key".path;
			cert = config.sops.secrets."syncthing-PET-cert".path;

		};
	};
} 
