{ config, lib, pkgs-default, ... }:
let
  # Generate the nix flake update command with all specified inputs
  updateCommand = 
    let
      inputs = lib.concatStringsSep " " config.system.inputUpdates;
    in
    ''
      cd ${config.host.settings.dotfilesDir}
      ${pkgs-default.nix}/bin/nix flake update ${inputs}
    '';

  # Create a wrapper script
  updateInputsScript = pkgs-default.writeShellScriptBin "update-flake-inputs" ''
    set -e
    echo "Updating flake inputs: ${lib.concatStringsSep ", " config.system.inputUpdates}"
    ${updateCommand}
    echo "Flake inputs updated successfully!"
  '';

in
{
  # Add the script to system packages
  environment.systemPackages = [ updateInputsScript ];
}