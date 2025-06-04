{ lib, config, pkgs-default, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
	    (import ./configs/importer.nix { inherit lib config pkgs-default settings; })
	    (import ./options.nix { inherit lib config settings; })
  	];
}