{ lib, config, settings, pkgs-default, pkgs-stable, pkgs-unstable, currentHost, ... }:
{
	imports = [
		(import ./config.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings currentHost; })
		(import ./options.nix { inherit lib config settings; })
	];
} 
