{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			programs.zsh = {
			    enable = true;
			    autosuggestion = {
			    	enable = true;
			    	highlight = "fg=#8c9ebf,bold,underline";
			    };
			    syntaxHighlighting.enable = true;
			    enableCompletion = true;
			    autocd = true;
			    initContent = ''
			    PROMPT="${config.defaults.shell.initPrompt}";
			     
			    if [[ -n "$DIRENV_DIR" ]]; then
				    PROMPT="%F{green}❄️ nix-shell%f $PROMPT"
				fi
			    '';

			    oh-my-zsh = {
			    	enable = true;

			    };
			  };
		};
	};
} 
