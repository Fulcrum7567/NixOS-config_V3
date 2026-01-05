{ lib, config, settings, pkgs-default, pkgs-stable, pkgs-unstable, sops-nix, ... }:
{
	imports = [
		(import ./config.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings sops-nix; })
		(import ./options.nix { inherit lib config settings; })
	];
} 
