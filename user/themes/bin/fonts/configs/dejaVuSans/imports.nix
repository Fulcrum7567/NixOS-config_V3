{ lib, config, inputs, pkgs, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
		(import ./config.nix { inherit lib config inputs pkgs pkgs-default pkgs-stable pkgs-unstable settings; })
	    (import ./options.nix { inherit lib config settings; })
	];
} 
