{ lib, config, pkgs, pkgs-default, pkgs-stable, pkgs-unstable, inputs, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
	    (import ./configs/importer.nix { inherit lib config pkgs pkgs-default pkgs-stable pkgs-unstable settings inputs; })
	    (import ./options.nix { inherit lib config settings; })
  	];
}