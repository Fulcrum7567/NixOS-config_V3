{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		virtualisation.docker.enable = true;

		users.users.${config.user.settings.username}.extraGroups = [ "docker" ];
	};
}