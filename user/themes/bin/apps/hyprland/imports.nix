{ config, lib, ... }:
{
  imports = [
    ./bin/importer.nix
    ./cursor.nix
  ];
}