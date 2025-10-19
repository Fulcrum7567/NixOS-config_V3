{ config, lib, ... }:
{
  options.system = {
    inputUpdates = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "nixpkgs-stable" "nixpkgs-unstable" "home-manager-stable" "home-manager-unstable" ];
      description = "List of input channels to update.";
      apply = x: lib.unique x;
    };
  };

  config.system.inputUpdates = [ "nixpkgs-stable" "nixpkgs-unstable" "home-manager-stable" "home-manager-unstable" ];
}