{ config, lib, ... }:
{
  config = lib.mkIf (config.server.services.forgejo.enable && (config.server.services.forgejo.activeConfig == "default")) {
    # Default configuration — no additional overrides needed
  };
}
