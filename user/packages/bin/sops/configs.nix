{ config, lib, pkgs-default, sops-nix, ... }:
{
	config = lib.mkIf config.packages.sops.enable {

		system.inputUpdates = [ "sops-nix" ];

		environment.systemPackages = with pkgs-default; [
			sops
		];

		sops ={
			defaultSopsFile = ../../../secrets/secrets.json;
			defaultSopsFormat = "json";

			validateSopsFiles = true;

			age = {
				sshKeyPaths = [];
				keyFile = "/home/${config.user.settings.username}/.config/sops/age/keys.txt";
			};
		};
	};
} 
