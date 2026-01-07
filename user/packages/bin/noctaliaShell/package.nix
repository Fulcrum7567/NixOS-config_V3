{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, noctalia, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		environment.systemPackages = with pkgs-default; [
			noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
		];
		
		home-manager.users.${config.user.settings.username}= {
			imports = [
				noctalia.homeModules.default
			];

			programs.noctalia-shell.enable = true;
		};
		
	};
}