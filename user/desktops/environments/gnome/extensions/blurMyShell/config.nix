{ config, lib, pkgs, ... }:
{
	config = lib.mkIf config.desktopEnvironments.gnome.extensions.blurMyShell.enable {
		environment.systemPackages = with pkgs.gnomeExtensions; [
			blur-my-shell
		];
		home-manager.users.${config.user.settings.username} =  {
			dconf.settings = {

				# Enable extension

				"org/gnome/shell" = {
					disable-user-extensions = false;
					enabled-extensions = [
						pkgs.gnomeExtensions.blur-my-shell.extensionUuid
					];
				};


				# Configure extension

				"org/gnome/shell/extensions/blur-my-shell/appfolder" = {
					brightness = 0.6;
					sigma = 30;
				};

				"org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
					pipeline = "pipeline_default";
				};


				"org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
					pipeline = "pipeline_default";
				};

				"org/gnome/shell/extensions/blur-my-shell/overview" = {
					pipeline = "pipeline_default";
				};

				"org/gnome/shell/extensions/blur-my-shell/panel" = {
					brightness = 0.6;
					pipeline = "pipeline_default";
					sigma = 30;
				};

				"org/gnome/shell/extensions/blur-my-shell/screenshot" = {
					pipeline = "pipeline_default";
				};

				"org/gnome/shell/extensions/blur-my-shell/window-list" = {
					brightness = 0.6;
					sigma = 30;
				};

				# End of extension configuration
			};
		};
	};
}