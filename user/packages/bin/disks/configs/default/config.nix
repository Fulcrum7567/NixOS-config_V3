{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		security.polkit.extraConfig = ''
			polkit.addRule(function(action, subject) {
			if (subject.isInGroup("wheel") && action.id.indexOf("org.freedesktop.udisks2.") == 0) {
				return polkit.Result.YES;
			}
			});
		'';

		home-manager.users.${config.user.settings.username} = {
			
		};
	};
} 
