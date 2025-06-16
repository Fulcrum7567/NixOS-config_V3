{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			programs.vscode.profiles.default = {
				enableUpdateCheck = false;
				extensions = with pkgs-default; [
					vscode-extensions.github.copilot
					vscode-extensions.github.copilot-chat
				];

				userSettings = {
					  "chat.editor.fontFamily" = "JetBrainsMono Nerd Font Mono";
					  "chat.editor.fontSize" = 20.0;
					  "debug.console.fontFamily" = "JetBrainsMono Nerd Font Mono";
					  "debug.console.fontSize" = 20.0;
					  "editor.fontFamily" = "JetBrainsMono Nerd Font Mono";
					  "editor.fontSize" = 20.0;
					  "editor.inlayHints.fontFamily" = "JetBrainsMono Nerd Font Mono";
					  "editor.inlineSuggest.fontFamily" = "JetBrainsMono Nerd Font Mono";
					  "editor.minimap.sectionHeaderFontSize" = 12.857142857142858;
					  "markdown.preview.fontFamily" = "DejaVu Sans";
					  "markdown.preview.fontSize" = 20.0;
					  "scm.inputFontFamily" = "JetBrainsMono Nerd Font Mono";
					  "scm.inputFontSize" = 18.571428571428573;
					  "screencastMode.fontSize" = 80.0;
					  "terminal.integrated.fontSize" = 20.0;
					  "update.mode" = "none";
					  "workbench.colorTheme" = "Stylix";
					  "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
					  "explorer.compactFolders" = false;
					  "scm.compactFolders" = false;
				};
			};
		};
	};
} 
