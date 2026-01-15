{ config, lib, ... }:
{
  options.server = {
    webaddress = lib.mkOption {
      type = lib.types.str;
      description = "The web address of the server.";
      example = "myserver.example.com";
    };
  };
}