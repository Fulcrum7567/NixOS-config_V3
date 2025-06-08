{ lib, config, settings, inputs, pkgs-default, pkgs, pkgs-stable, pkgs-unstable, ... }:
{
	imports = [
		(import ./config.nix { inherit lib config settings inputs pkgs pkgs-default pkgs-stable pkgs-unstable; })
		(import ./options.nix { inherit lib config settings; })
	];
} 
