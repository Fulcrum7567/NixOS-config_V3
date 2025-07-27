{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			xdg.desktopEntries = {
				nvim = {
					name = "Neovim";
					genericName = "Neovim";
					exec = "kitty nvim";
					icon = "nvim";
					categories = [  ];
					noDisplay = true;
				};
			};
		};

		programs.nvf.settings.vim = {
			viAlias = false;
			vimAlias = true;

			lsp.enable = true;

			statusline.lualine.enable = true;
			telescope.enable = true;
			autocomplete.nvim-cmp.enable = true;

			languages = {
				enableTreesitter = true;

				nix.enable = true;
				ts.enable = true;
				python.enable = true;
			};

		};
	};
} 
