{ config, lib, pkgs-default, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
		(import ./configs/importer.nix { inherit lib config settings pkgs-default; })
		(import ./options.nix { inherit config lib settings pkgs-default; })
	];	
} 
