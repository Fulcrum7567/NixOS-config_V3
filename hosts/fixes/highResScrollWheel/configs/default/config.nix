{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.fixes.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		environment.etc."libinput/local-overrides.quirks".text = lib.mkForce ''
[Logitech G903 Lightspeed]
MatchName=*
AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
'';
	};
} 
