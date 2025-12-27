{ config, lib, ... }:
let color = config.colorScheme.palette; in
{
  config = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.colors.enable && (config.theming.apps.waybar.colors.activeConfig == "dynamic"))) {
    theming.apps.waybar.style = [
      {
        order = 100;
        content = ''
          @define-color base00 #${color.base00}; #2E3440
          @define-color base01 #${color.base01}; #3B4252
          @define-color base02 #${color.base02}; #434C5E
          @define-color base03 #${color.base03}; #4C566A
          @define-color base04 #${color.base04}; #D8DEE9
          @define-color base05 #${color.base05}; #E5E9F0
          @define-color base06 #${color.base06}; #ECEFF4
          @define-color base07 #${color.base07}; #8FBCBB
          @define-color base08 #${color.base08}; #88C0D0
          @define-color base09 #${color.base09}; #81A1C1
          @define-color base0A #${color.base0A}; #5E81AC
          @define-color base0B #${color.base0B}; #BF616A
          @define-color base0C #${color.base0C}; #D08770
          @define-color base0D #${color.base0D}; #EBCB8B
          @define-color base0E #${color.base0E}; #A3BE8C
          @define-color base0F #${color.base0F}; #B48EAD
        '';
      }
    ];
  };
}