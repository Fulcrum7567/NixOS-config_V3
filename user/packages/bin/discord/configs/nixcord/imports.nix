{ lib, config, settings, inputs, pkgs-default,  ... }:
{
	imports = [
		(import ./config.nix { inherit lib config inputs settings pkgs-default; })
		(import ./options.nix { inherit lib config settings; })
	];
} 
