{ config, lib, inputs, ... }:
let
  cfg = config.server.services.vscodeServer;
in
{
  imports = [
    inputs.vscode-server.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    services.vscode-server.enable = true;
  };
}