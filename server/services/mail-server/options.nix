{ config, lib, ... }:
{
  options.server.services.mail-server = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Email service.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available Email configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.server.services.mail-server.availableConfigs or []);
      default = "stalwart";
      description = "The active Email configuration.";
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "stalwart";
      description = "The subdomain to host the Email service on.";
    };

    fullDomainName = lib.mkOption {
      type = lib.types.str;
      default = "${config.server.services.mail-server.subdomain}.${config.server.webaddress}";
      description = "The full domain name to access the Email service.";
    };

    fullHttpsUrl = lib.mkOption {
      type = lib.types.str;
      default = "https://${config.server.services.mail-server.fullDomainName}";
      description = "The full HTTPS URL to access the Email service.";
    };

    # ── SMTP Relay Options ────────────────────────────────────────────────
    # Use these to relay outbound mail through a VPS or other SMTP server
    # when your ISP blocks outbound port 25.
    relay = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable SMTP relay for outbound mail delivery.
          When enabled, outgoing mail is sent through the configured relay
          host instead of directly via MX resolution. This is required when
          your ISP blocks outbound port 25.
        '';
      };

      address = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The hostname or IP address of the SMTP relay server.";
        example = "relay.example.com";
      };

      port = lib.mkOption {
        type = lib.types.int;
        default = 25;
        description = "The port on the relay server to connect to.";
        example = 587;
      };

      auth = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether the relay server requires authentication.";
        };

        username = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Username for relay server authentication.";
        };
      };

      tls = {
        implicit = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to use implicit TLS (connect directly over TLS).
            When false, STARTTLS will be used to upgrade a plain connection.
          '';
        };

        allow-invalid-certs = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to accept invalid or self-signed TLS certificates.";
        };
      };
    };

  };
}