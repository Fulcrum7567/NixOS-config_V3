{ config, lib, pkgs-default, ... }:
{
	config = lib.mkIf (config.packages.defaults.shell.active == "zsh") {
		packages = {
			zsh.enable = true;
			defaults.shell.initPrompt = " ◉ %U%F{magenta}%n%f%u@%U%F{blue}%m%f%u:%F{yellow}%~%f
	     %F{green}→%f ";
	     };

	    programs.direnv = {
		    enable = true;
		    nix-direnv.enable = true;
		    enableZshIntegration = true;
		};

		users.defaultUserShell = pkgs-default.zsh;
	};
}