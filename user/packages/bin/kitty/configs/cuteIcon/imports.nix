{ lib, config, settings, pkgs-default,  ... }:
{
	imports = [
		(import ./config.nix { inherit lib config settings pkgs-default; })
		(import ./options.nix { inherit lib config settings; })
	];
} 
