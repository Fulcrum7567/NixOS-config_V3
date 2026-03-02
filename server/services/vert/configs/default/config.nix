{ config, lib, ... }:
{
  config = lib.mkIf (config.server.services.vert.enable && (config.server.services.vert.activeConfig == "default")) {
    # Default configuration — no additional overrides needed
  };
}
