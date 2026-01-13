{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		nix.settings.experimental-features = [ "nix-command" "flakes" ];

		nixpkgs.config.allowUnfree = true;

		networking.hostName = config.host.settings.hostName;

		services.xserver.excludePackages = [ pkgs-default.xterm ];
		
	};
} 
