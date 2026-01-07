{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, self, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		system.nixos.tags = [

			"${config.desktops.activeDesktop}"
			"Git-commit:_${(self.rev or (self.dirtyRev or "dirty"))}_"
		];

	};
} 
