{ lib, config, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	imports = [
		(import ./config.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings; })
		(import ./options.nix { inherit lib config settings; })
	];
} 
