{ config, lib, ... }:
let
  locales12h = [
    "en_US.UTF-8"
    "en_CA.UTF-8"
    "en_AU.UTF-8"
    "en_NZ.UTF-8"
    "en_PH.UTF-8"
  ];

  timeLocale = config.i18n.extraLocaleSettings.LC_TIME or config.i18n.defaultLocale;
  is12h = builtins.elem timeLocale locales12h;
in
{
  config = lib.mkIf (config.packages.waybar.modules.clock.enable && (config.packages.waybar.modules.clock.activeConfig == "slyHarvey")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "clock" = {
        format = if is12h then "{:%a %d %b %I:%M %p}" else "{:%a %d %b %R}";
        format-alt = if is12h then "{:%a %d %b %R}" else "{:%a %d %b %I:%M %p}";
        # format = "{:%a %d %b %R}";
        # format = "{:%R 󰃭 %d·%m·%y}"; # Inverted
        # format-alt = "{:%I:%M %p}";
        tooltip-format = "<tt>{calendar}</tt>";
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          on-scroll = 1;
          on-click-right = "mode";
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b>{}</b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-click-forward = "tz_up";
          on-click-backward = "tz_down";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };
    };
  };
}