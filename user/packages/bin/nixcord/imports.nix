{ lib, config,  inputs, pkgs-default, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
	    (import ./configs/importer.nix { inherit lib config inputs settings pkgs-default; })
	    (import ./options.nix { inherit lib config settings; })
			./config.nix
  	];
}