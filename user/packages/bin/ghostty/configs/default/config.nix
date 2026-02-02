{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			programs.ghostty = {
				installVimSyntax = true;
				installBatSyntax = true;
				enableZshIntegration = config.packages.zsh.enable;
				enableFishIntegration = config.packages.fish.enable or false;
				
				settings = {
					background-opacity = 0.8;
					background-blur = true;
				};
				
			};
		};

		# programs.nautilus-open-any-terminal.enable = lib.mkForce false;
	};
} 
