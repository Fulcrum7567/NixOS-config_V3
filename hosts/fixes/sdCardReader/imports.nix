{ lib, config, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
	    (import ./configs/importer.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings pkgs; })
	    (import ./options.nix { inherit lib config settings; })
  	];
}