{ lib, config, settings, pkgs, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
{
	imports = [
		(import ./config.nix { inherit lib config pkgs pkgs-default pkgs-stable pkgs-unstable settings; })
		(import ./options.nix { inherit lib config settings; })
	];
} 
