{ lib, config, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
{
	imports = [
		(import ./config.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings pkgs; })
		(import ./options.nix { inherit lib config settings; })
	];
} 
