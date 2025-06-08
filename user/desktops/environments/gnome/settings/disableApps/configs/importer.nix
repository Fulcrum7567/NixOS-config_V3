{ lib, config, settings, inputs, pkgs-default, pkgs, pkgs-stable, pkgs-unstable, ... }:

let
  # 1) Get all directory names
  allNames = builtins.attrNames (builtins.readDir ./.);

  # 2) Filter only those with an `imports.nix` file
  hasImporter = name:
    builtins.pathExists (./${name}/imports.nix);

  validDirs = lib.filter hasImporter allNames;

  # 3) Map valid directories to function imports, passing config/lib/settings
  importerPaths = lib.map
    (name: import ./${name}/imports.nix { inherit lib config settings inputs pkgs pkgs-default pkgs-stable pkgs-unstable; })
    validDirs;
in
{
  imports = importerPaths;
}

