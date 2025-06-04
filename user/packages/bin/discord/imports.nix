{ lib, config,  inputs, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
	    (import ./configs/importer.nix { inherit lib config inputs settings; })
	    (import ./options.nix { inherit lib config settings; })
  	];
}