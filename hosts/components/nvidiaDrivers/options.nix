{ config, lib, settings, ... }:
{
	options.hosts.components.${settings.optionName} = {

		availableConfigs = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available configs for the ${settings.displayName} component.";
		};

		activeConfig = lib.mkOption {
			type = lib.types.enum (config.hosts.components.${settings.optionName}.availableConfigs or []);
			default = "default"; # A default config should always exist, delete if not
			description = "Set the active configuration for the ${settings.displayName} component.";
		};

		powerManagement = lib.mkOption {
			type = lib.types.enum [
				"enabled"
				"finegrained"
				"disabled"
			];
			description = "Set the type of powerManagement";
			default = "enabled";
		};

		nvidiaSettings = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable NVidia settings app.";
		};

		dynamicBoost = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable dynamic boost.";
		};

		package = lib.mkOption {
			type = lib.types.package;
			default = config.boot.kernelPackages.nvidiaPackages.stable;
			description = "Set the package of the nvidia driver.";
		};

		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable ${settings.displayName} components.";
		};
	};
}