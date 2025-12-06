{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {


		boot.kernelParams = let
		# 1. Get all display values as a list (ignoring the "LG-UltraGear" keys)
		allDisplays = lib.attrValues config.hardware.displays;

		# 2. Split into primary and non-primary
		# (Using 'd.primary or false' allows it to work even if you omitted the line on secondary monitors)
		primary = lib.filter (d: d.primary or false) allDisplays;
		others = lib.filter (d: !(d.primary or false)) allDisplays;

		# 3. Recombine with primary first
		sortedDisplays = primary ++ others;

		# 4. Define how to format the string
		makeKernelParam = d: "video=${d.name}:${d.resolution}@${toString d.refreshRate}";
	in
		map makeKernelParam sortedDisplays;


	};
} 
