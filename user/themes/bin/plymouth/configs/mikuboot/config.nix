{ config, lib, inputs, pkgs, ... }:
{
  imports = [
		inputs.mikuboot.nixosModules.default
	];

  config = lib.mkIf (config.theming.plymouth.activeTheme == "mikuboot") {
    
    system.inputUpdates = [ "mikuboot" ];

    boot.plymouth = {
      themePackages = lib.mkForce [ pkgs.mikuboot ];
      theme = lib.mkForce "mikuboot";
    };
  };
}