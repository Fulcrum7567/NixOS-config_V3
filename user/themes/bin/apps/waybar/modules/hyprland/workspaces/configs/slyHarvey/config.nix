{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.hyprland.workspaces.enable && (config.theming.apps.waybar.modules.hyprland.workspaces.activeConfig == "slyHarvey"))) {
    style = [
      {
        content = ''
          #workspaces button {
              box-shadow: none;
          	text-shadow: none;
              padding: 0px;
              border-radius: 9px;
              padding-left: 4px;
              padding-right: 4px;
              animation: gradient_f 20s ease-in infinite;
              transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
          }

          #workspaces button:hover {
          	border-radius: 10px;
          	color: @overlay0;
          	background-color: @surface0;
           	padding-left: 2px;
              padding-right: 2px;
              animation: gradient_f 20s ease-in infinite;
              transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
          }

          #workspaces button.persistent {
          	color: @surface1;
          	border-radius: 10px;
          }

          #workspaces button.active {
          	color: @peach;
            	border-radius: 10px;
              padding-left: 8px;
              padding-right: 8px;
              animation: gradient_f 20s ease-in infinite;
              transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
          }

          #workspaces button.urgent {
          	color: @red;
           	border-radius: 0px;
          }
        '';
      }
    ];
  };
}