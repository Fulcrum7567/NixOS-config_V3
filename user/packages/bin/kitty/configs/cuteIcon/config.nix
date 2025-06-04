{ config, lib, settings, pkgs-default, ... }:
let
	option = config.packages.${settings.optionName};
	customKitty = pkgs-default.kitty.overrideAttrs (oldAttrs: {
	    postInstall = oldAttrs.postInstall or "" + ''
	      substituteInPlace $out/share/applications/kitty.desktop \
	        --replace "Icon=kitty" "Icon=./kitty.png"
	    '';
	});
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "cuteIcon")) {
		home-manager.users.${config.user.settings.username} = {
			programs.kitty = {
				enable = true;
				package = customKitty;
			};
		};
	};
} 
