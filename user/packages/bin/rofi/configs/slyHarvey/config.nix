{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "slyHarvey")) {
		home-manager.users.${config.user.settings.username} = {

			xdg.configFile."rofi/launchers" = {
				source = ./launchers;
				recursive = true;
			};
			xdg.configFile."rofi/colors" = {
				source = ./colors;
				recursive = true;
			};
			
			programs.rofi = {
				terminal = config.packages.defaults.terminal.launchCommand;
				plugins = with pkgs-default; [
					rofi-emoji # https://github.com/Mange/rofi-emoji 🤯
          			rofi-games # https://github.com/Rolv-Apneseth/rofi-games 🎮
				];


				extraConfig = {
					# ---------- General setting ----------
					modi = "drun,run,filebrowser,window";
					case-sensitive = false;
					cycle = true;
					filter = "";
					scroll-method = 0;
					normalize-match = true;

					# ---------- Matching setting ----------
					matching = "normal";
					tokenize = true;

					# ---------- SSH settings ----------
					ssh-client = "ssh";
					ssh-command = "{terminal} -e {ssh-client} {host} [-p {port}]";
					parse-hosts = true;
					parse-known-hosts = true;

					# ---------- Drun settings ----------
					drun-categories = "";
					drun-match-fields = "name,generic,exec,categories,keywords";
					drun-display-format = "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
					drun-show-actions = false;
					drun-url-launcher = "xdg-open";
					drun-use-desktop-cache = false;
					drun-reload-desktop-cache = false;

					# ---------- Run settings ----------
					run-command = "{cmd}";
					run-list-command = "";
					run-shell-command = "{terminal} -e {cmd}";

					# ---------- Window switcher settings ----------
					window-match-fields = "title,class,role,name,desktop";
					window-command = "wmctrl -i -R {window}";
					window-format = "{w} - {c} - {t:0}";
					window-thumbnail = false;

					# ---------- Combi settings ----------
					# combi-modi = "window,run";
					# combi-hide-mode-prefix = false;
					# combi-display-format = "{mode} {text}";

					# ---------- History and Sorting ----------
					disable-history = false;
					sorting-method = "normal";
					max-history-size = 25;

					# ---------- Display setting ----------
					display-window = "Windows";
					display-windowcd = "Window CD";
					display-run = "Run";
					display-ssh = "SSH";
					display-drun = "Apps";
					display-combi = "Combi";
					display-keys = "Keys";
					display-filebrowser = "Files";

					# ---------- Misc setting ----------
					terminal = "rofi-sensible-terminal";
					sort = false;
					threads = 0;
					click-to-exit = true;
					# ignored-prefixes = "";
					# pid = "/run/user/1000/rofi.pid";
				};
			};
		};
	};
} 
