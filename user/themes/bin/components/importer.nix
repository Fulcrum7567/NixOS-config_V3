{ lib, ... }:

let
  # 1) get a list of all names under this directory
  allNames = builtins.attrNames (builtins.readDir ./.);

  # 2) keep only those names which have an imports.nix inside
  hasImporter = name:
    builtins.pathExists (./${name}/imports.nix);

  validDirs = lib.filter hasImporter allNames;

  # 3) build the final imports list
  importerPaths = lib.map (name: ./${name}/imports.nix) validDirs;
in
{
  imports = importerPaths;
}
