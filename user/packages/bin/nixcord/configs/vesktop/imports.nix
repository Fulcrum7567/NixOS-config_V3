{ lib, config, settings, inputs, pkgs-default, pkgs-stable, ... }:
{
	imports = [
		(import ./config.nix { inherit lib config inputs settings pkgs-default pkgs-stable; })
		(import ./options.nix { inherit lib config settings; })
	];
} 
