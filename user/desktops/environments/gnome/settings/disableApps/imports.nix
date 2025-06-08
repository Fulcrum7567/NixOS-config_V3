{ config, lib, inputs, pkgs, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
		(import ./configs/importer.nix { inherit lib config settings inputs pkgs pkgs-default pkgs-stable pkgs-unstable; })
		(import ./options.nix { inherit config lib settings; })
	];	
} 
