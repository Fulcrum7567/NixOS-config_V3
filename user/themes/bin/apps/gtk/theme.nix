{ config, lib, ... }:
{
  config = {
		home-manager.users.${config.user.settings.username} = lib.mkIf (config.theming.gtk.theme.override) {
			gtk = {
				enable = true;

				theme.name = lib.mkForce config.theming.gtk.theme.value.name;
				theme.package = lib.mkForce config.theming.gtk.theme.value.package;
			};
		};
  };
}