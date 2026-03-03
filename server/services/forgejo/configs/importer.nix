{ lib, ... }:

let
  allNames = builtins.attrNames (builtins.readDir ./.);
  hasImporter = name:
    builtins.pathExists (./${name}/imports.nix);
  validDirs = lib.filter hasImporter allNames;
  importerPaths = lib.map (name: ./${name}/imports.nix) validDirs;
in
{
  imports = importerPaths;
}
