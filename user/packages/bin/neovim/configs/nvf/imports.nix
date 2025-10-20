{ lib, config, nvf, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
{
	imports = [
		(import ./config.nix { inherit lib config nvf pkgs-default pkgs-stable pkgs-unstable settings; })
		(import ./options.nix { inherit lib config settings; })
	];
} 
