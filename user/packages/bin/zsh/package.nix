{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		# Package installation
		environment.shells = with pkgs-default; [ zsh ];
		programs.zsh.enable = true;
		
	};
}