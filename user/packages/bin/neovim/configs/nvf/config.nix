{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{

	imports = [
		nvf.nixosModules.default
	];
	
	config = lib.mkIf (option.enable && (option.activeConfig == "nvf")) {

		system.inputUpdates = [ "nvf-unstable" "nvf-stable" ];

		home-manager.users.${config.user.settings.username} = {

			programs.nvf = {
				enable = true;
				settings.vim = {
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
						java.enable = true;
					};

				};
			};
		};
	};
} 
