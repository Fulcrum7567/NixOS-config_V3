{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		home-manager.users.${config.user.settings.username} = {
			programs.cava = {
				enable = true;
			};
		};

		environment.systemPackages = with pkgs-default; [
			iniparser
		];
	};
}