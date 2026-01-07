{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			/* No longer necessary with dconf cinnamon settings
			home.file.".local/share/nemo/actions/open-in-${config.packages.defaults.terminal.active}.nemo_action".text = ''
				[Nemo Action]

				Name=Open in ${config.packages.defaults.terminal.active}
				Comment=Open the '${config.packages.defaults.terminal.active}' terminal in the selected folder
				Exec=${builtins.replaceStrings [ "<path>" ] [ "%F" ] config.packages.defaults.terminal.launchAtPathCommand} 
				Icon-Name=${config.packages.defaults.terminal.active}
				Selection=any
				Extensions=dir;
				EscapeSpaces=true
			'';
			*/

			dconf.settings = {
				"org/cinnamon/desktop/applications/terminal" = {
					exec = "${lib.replaceStrings [ "<path>" ] [ "$PWD" ] config.packages.defaults.terminal.launchAtPathCommand}";      # Replace with your terminal command (e.g., kitty, wezterm, foot)
					exec-arg = "-e";         # Argument to execute a command (common defaults: -e, -x, or leave empty)
				};

					"org/nemo/preferences" = {
						default-terminal = config.packages.defaults.terminal.launchCommand;
					};

					"org/nemo/preferences" = {
					show-hidden-files = true;
					click-double-parent-folder = true;
					close-device-view-on-device-eject = true;
					executable-text-activation = "display"; # Options: "ask", "run", "display"
					"inherit-show-thumbnails" = true;
					quick-rename-with-pause-in-between = true;
					show-advanced-permissions = true;
					show-compact-view-icon-toolbar = false;
					show-full-path-titles = false;
					show-home-icon-toolbar = true;
					show-icon-view-icon-toolbar = false;
					show-list-view-icon-toolbar = false;
					show-open-in-terminal-toolbar = true;
					show-show-thumbnails-toolbar = false;
					show-toggle-extra-pane-toolbar = false;
					sort-directories-first = true;
					thumbnail-limit = 10485760; # 10 MB
					tooltips-in-list-view = true;
					tooltips-show-access-date = true;
					tooltips-show-birth-date = true;
					tooltips-show-file-type = true;
					tooltips-show-mod-date = true;
					tooltips-show-path = true;

					default-folder-viewer = "list-view";  # Options: "icon-view", "list-view", "compact-view"
					show-home-icon-on-desktop = true;
					show-trash-icon-on-desktop = true;
					confirm-trash = true;
				};

				"org/nemo/preferences/menu-config" = {
					background-menu-open-in-terminal = true;
					desktop-menu-customize = false;
					selection-menu-open-in-terminal = true;
				};

				"org/nemo/compact-view" = {
					zoom-level = "default";
					all-columns-have-same-width = false;
				};

				"org/nemo/list-view" = {
					default-column-order = [ "name" "size" "type" "date_modified" "date_created_with_time" "date_accessed" "date_created" "detailed_type" "group" "where" "mime_type" "date_modified_with_time" "octal_permissions" "owner" "permissions"];
					default-visible-columns = [ "name" "size" "type" "date_modified" "permissions" ];
					zoom-level = "default";
					enable-folder-expansion = false;
				};

				"org/nemo/window-state" = {
					start-with-toolbar = true;
					start-with-status-bar = true;
					start-with-sidebar = true;
					sidebar-width = 200;
					maximized = true;
				};
			};
		};
	};
} 
