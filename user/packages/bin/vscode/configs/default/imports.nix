{ lib, config, settings, pkgs-default, pkgs-stable, pkgs-unstable, inputs, ... }:
{
	imports = [
		(import ./config.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings inputs; })
		(import ./options.nix { inherit lib config settings; })
	];
} 
