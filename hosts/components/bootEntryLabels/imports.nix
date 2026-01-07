{ lib, config, pkgs-default, pkgs-stable, pkgs-unstable, self, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
	    (import ./configs/importer.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings self; })
	    (import ./options.nix { inherit lib config settings; })
  	];
}