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
  config = lib.mkIf (config.theming.apps.wlogout.enable && (config.theming.apps.wlogout.activeConfig == "sheng")) {
    home-manager.users.${config.user.settings.username} = {
      programs.wlogout = {
        style = ''
          /* ----------- 💫 https://github.com/JaKooLit 💫 -------- */
            /* pywal-wlogout */

            /* Importing pywal colors */

            @define-color foreground #c4dae1;
            @define-color background #11151d;
            @define-color cursor #c4dae1;

            @define-color color0 #11151d;
            @define-color color1 #AB736C;
            @define-color color2 #5A7393;
            @define-color color3 #6B8CB0;
            @define-color color4 #7CA3C3;
            @define-color color5 #9CA7AC;
            @define-color color6 #88B0C8;
            @define-color color7 #c4dae1;
            @define-color color8 #89989d;
            @define-color color9 #AB736C;
            @define-color color10 #5A7393;
            @define-color color11 #6B8CB0;
            @define-color color12 #7CA3C3;
            @define-color color13 #9CA7AC;
            @define-color color14 #88B0C8;
            @define-color color15 #c4dae1;


            window {
                font-family: Fira Code Medium;
                font-size: 16pt;
                color:  @foreground; /* text */
                background-color: rgba(24, 27, 32, 0.2);

            } 

            button {
                background-repeat: no-repeat;
                background-position: center;
                background-size: 20%;
                background-color: transparent;
                animation: gradient_f 20s ease-in infinite;
                transition: all 0.3s ease-in;
                box-shadow: 0 0 10px 2px transparent;
                border-radius: 36px;
                margin: 10px;
            }

            button:focus {
                box-shadow: none;
                background-size : 20%;
            }

            button:hover {
                background-size: 50%;
                box-shadow: 0 0 10px 3px rgba(0,0,0,.4);
                background-color: @color6;
                color: transparent;
                transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
            }

            #shutdown {
                background-image: image(url("${./icons/power.png}"));
            }
            #shutdown:hover {
            background-image: image(url("${./icons/power-hover.png}"));
            }

            #logout {
                background-image: image(url("${./icons/logout.png}"));
            }
            #logout:hover {
            background-image: image(url("${./icons/logout-hover.png}"));
            }

            #reboot {
                background-image: image(url("${./icons/restart.png}"));
            }
            #reboot:hover {
            background-image: image(url("${./icons/restart-hover.png}"));
            }

            #lock {
                background-image: image(url("${./icons/lock.png}"));
            }
            #lock:hover {
            background-image: image(url("${./icons/lock-hover.png}"));
            }

            #hibernate {
                background-image: image(url("${./icons/hibernate.png}"));
            }
            #hibernate:hover {
            background-image: image(url("${./icons/hibernate-hover.png}"));
            }

            #suspend {
                background-image: image(url("${./icons/suspend.png}"));
            }
            #suspend:hover {
            background-image: image(url("${./icons/suspend-hover.png}"));
            }
        '';
      };
    };
  };
}