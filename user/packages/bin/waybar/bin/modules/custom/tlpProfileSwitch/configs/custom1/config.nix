{ config, lib, pkgs-default, ... }:
let
  # The script that cycles modes and outputs JSON for Waybar
  tlp-switcher = pkgs-default.writeShellScriptBin "tlp-switcher" ''
    STATE_FILE="/tmp/tlp-switcher-state"
    
    # 1. READ CURRENT STATE (Default to 'auto' if file doesn't exist)
    if [ -f "$STATE_FILE" ]; then
      CURRENT_MODE=$(cat "$STATE_FILE")
    else
      CURRENT_MODE="auto"
    fi

    # 2. TOGGLE LOGIC (If argument 'toggle' is passed)
    if [ "$1" == "toggle" ]; then
      case "$CURRENT_MODE" in
        "auto")
          # Switch to Performance (Force AC settings)
          sudo tlp ac
          NEXT_MODE="performance"
          ;;
        "performance")
          # Switch to Battery Saver (Force BAT settings - No Turbo)
          sudo tlp bat
          NEXT_MODE="saver"
          ;;
        *)
          # Switch back to Auto (Standard TLP behavior)
          sudo tlp start
          NEXT_MODE="auto"
          ;;
      esac
      
      echo "$NEXT_MODE" > "$STATE_FILE"
      # Signal Waybar to update the icon immediately
      pkill -SIGRTMIN+8 waybar
      exit 0
    fi

    # 3. DISPLAY LOGIC (Output JSON for Waybar)
    case "$CURRENT_MODE" in
      "performance")
        TEXT="<span size='150%'></span>"
        TOOLTIP="Mode: Performance (Forced AC)"
        CLASS="performance"
        ;;
      "saver")
        TEXT="<span size='250%'></span>"
        TOOLTIP="Mode: Saver (Forced BAT)"
        CLASS="saver"
        ;;
      *)
        TEXT="<span size='250%'></span>"
        TOOLTIP="Mode: Automatic"
        CLASS="auto"
        ;;
    esac

    echo "{\"text\": \"$TEXT\", \"tooltip\": \"$TOOLTIP\", \"class\": \"$CLASS\"}"
  '';
in
{
  config = lib.mkIf (
    (config.hosts.components.powerManagement.activeConfig == "tlp") &&
    config.packages.waybar.modules.custom.tlpProfileSwitch.enable &&
    (config.packages.waybar.modules.custom.tlpProfileSwitch.activeConfig == "custom1")
   ) {
    environment.systemPackages = [ tlp-switcher ];
    security.sudo.extraRules = [{
    users = [ config.user.settings.username ]; 
    commands = [
      { 
        command = "${pkgs-default.tlp}/bin/tlp"; 
        options = [ "NOPASSWD" ]; 
      }
    ];
  }];
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "custom/tlpProfileSwitch" = {
        format = "{}";
        return-type = "json";
        interval = "once";
        exec = "tlp-switcher";
        on-click = "tlp-switcher toggle";
        signal = 8;
      };
    };
  };
}