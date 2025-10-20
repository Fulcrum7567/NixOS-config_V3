{ config, lib, ... }:
{
	options.desktops = {
		availableDesktops = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available desktops. Every desktop adds itself to this list.";
		};

		activeDesktop = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum (config.desktops.availableDesktops or []));
			description = "Set the active desktop. Must exist in user/desktops/profiles.";
		};

		sessionType = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum [ "x11" "wayland" ]);
			description = "Set the session type to use.";
		};
	};
}