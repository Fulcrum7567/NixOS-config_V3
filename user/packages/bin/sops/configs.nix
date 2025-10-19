{ config, lib, pkgs-default, ... }:
{
	config = lib.mkIf config.packages.sops.enable {

		system.inputUpdates = [ "sops-nix" ];

		environment.systemPackages = with pkgs-default; [
			sops
		];

		sops.age.keyFile = "/home/${config.user.settings.username}/.config/sops/age/keys.txt";
		sops.validateSopsFiles = false;
	};
} 
