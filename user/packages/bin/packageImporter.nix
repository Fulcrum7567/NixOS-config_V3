{ lib, ... }:
let
	imports-path = lib.findFiles {
		roor = ./.;
		pattern = "imports.nix";
		maxDepth = 1;
	};
in

map (path: import path) imports-path