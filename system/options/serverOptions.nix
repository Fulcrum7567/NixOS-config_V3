{ config, lib, ... }:
{
  options.server = {
    webaddress = lib.mkOption {
      type = lib.types.str;
      description = "The web address of the server.";
      example = "myserver.example.com";
    };

    dnsProvider = lib.mkOption {
      type = lib.types.str;
      default = "inwx";
      description = "The DNS provider used for ACME certificate generation.";
      example = "inwx";
    };
  };
}