{ config, lib, ... }:
let 
  fntSize = "22";
  BtnCol = "white";
  button_rad = "15";
  active_rad = "25";
  mgn = "10";
  hvr = "5";
in 
{
  config = lib.mkIf (config.theming.apps.wlogout.enable && (config.theming.apps.wlogout.activeConfig == "HyDE1")) {
    home-manager.users.${config.user.settings.username} = {
      programs.wlogout = {
        style = ''
          * {
              background-image: none;
              font-size: ${fntSize}px;
          }

          @define-color bar-bg rgba(31, 35, 40, 0.95);

          @define-color main-bg #101419;
          @define-color main-fg #93cee9;

          @define-color wb-act-bg #93cee9;
          @define-color wb-act-fg #1f2328;

          @define-color wb-hvr-bg #93cee9;
          @define-color wb-hvr-fg #1f2328;

          window {
              background-color: transparent;
          }

          button {
              color: ${BtnCol};
              background-color: @main-bg;
              outline-style: none;
              border: none;
              border-width: 0px;
              background-repeat: no-repeat;
              background-position: center;
              background-size: 20%;
              border-radius: 0px;
              box-shadow: none;
              text-shadow: none;
              animation: gradient_f 20s ease-in infinite;
          }

          button:focus {
              background-color: @wb-act-bg;
              background-size: 30%;
          }

          button:hover {
              background-color: @wb-hvr-bg;
              background-size: 40%;
              border-radius: ${active_rad}px;
              animation: gradient_f 20s ease-in infinite;
              transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
          }

          button:hover#lock {
              border-radius: ${active_rad}px;
              margin : ${hvr}px 0px ${hvr}px ${mgn}px;
          }

          button:hover#logout {
              border-radius: ${active_rad}px;
              margin : ${hvr}px 0px ${hvr}px 0px;
          }

          button:hover#suspend {
              border-radius: ${active_rad}px;
              margin : ${hvr}px 0px ${hvr}px 0px;
          }

          button:hover#shutdown {
              border-radius: ${active_rad}px;
              margin : ${hvr}px 0px ${hvr}px 0px;
          }

          button:hover#hibernate {
              border-radius: ${active_rad}px;
              margin : ${hvr}px 0px ${hvr}px 0px;
          }

          button:hover#reboot {
              border-radius: ${active_rad}px;
              margin : ${hvr}px ${mgn}px ${hvr}px 0px;
          }

          #lock {
              background-image: image(url("${../../bin/icons/lock_${BtnCol}.png}"));
              border-radius: ${button_rad}px 0px 0px ${button_rad}px;
              margin : ${mgn}px 0px ${mgn}px ${mgn}px;
          }

          #logout {
              background-image: image(url("${../../bin/icons/logout_${BtnCol}.png}"));
              border-radius: 0px 0px 0px 0px;
              margin : ${mgn}px 0px ${mgn}px 0px;
          }

          #suspend {
              background-image: image(url("${../../bin/icons/suspend_${BtnCol}.png}"));
              border-radius: 0px 0px 0px 0px;
              margin : ${mgn}px 0px ${mgn}px 0px;
          }

          #shutdown {
              background-image: image(url("${../../bin/icons/shutdown_${BtnCol}.png}"));
              border-radius: 0px 0px 0px 0px;
              margin : ${mgn}px 0px ${mgn}px 0px;
          }

          #hibernate {
              background-image: image(url("${../../bin/icons/hibernate_${BtnCol}.png}"));
              border-radius: 0px 0px 0px 0px;
              margin : ${mgn}px 0px ${mgn}px 0px;
          }

          #reboot {
              background-image: image(url("${../../bin/icons/reboot_${BtnCol}.png}"));
              border-radius: 0px ${button_rad}px ${button_rad}px 0px;
              margin : ${mgn}px ${mgn}px ${mgn}px 0px;
          }
        '';
      };
    };
  };
}