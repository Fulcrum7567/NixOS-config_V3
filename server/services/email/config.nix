{ config, lib, pkgs-default, ... }:
{
  config = lib.mkIf config.server.services.email.enable {

  };

    
}