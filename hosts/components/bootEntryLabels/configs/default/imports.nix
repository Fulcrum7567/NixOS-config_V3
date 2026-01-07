{ lib, config, settings, pkgs-default, pkgs-stable, pkgs-unstable, self, ... }:
{
	imports = [
		(import ./config.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings self; })
		(import ./options.nix { inherit lib config settings; })
	];
} 
