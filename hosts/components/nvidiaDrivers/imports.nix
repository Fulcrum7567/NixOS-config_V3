{ lib, config, pkgs, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
	    (import ./configs/importer.nix { inherit lib config pkgs pkgs-default pkgs-stable pkgs-unstable settings; })
	    (import ./options.nix { inherit lib config settings; })
  	];
}