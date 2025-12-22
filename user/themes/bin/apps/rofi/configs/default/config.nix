{ config, lib, ... }:
{
  config = lib.mkIf (config.theming.apps.rofi.enable && (config.theming.apps.rofi.activeConfig == "default")) {
	theming.apps.rofi.starConfig = let
				mkLiteral = value: {
					_type = "literal";
					inherit value;
				};
			in [
		{
		border-colour = lib.mkForce (mkLiteral              "var(selected)");
		handle-colour = lib.mkForce (mkLiteral               "var(selected)");
		background-colour = lib.mkForce (mkLiteral          "var(background)");
		foreground-colour = lib.mkForce (mkLiteral           "var(foreground)");
		alternate-background = lib.mkForce (mkLiteral        "var(background-alt)");
		normal-background = lib.mkForce (mkLiteral           "var(background)");
		normal-foreground = lib.mkForce (mkLiteral           "var(foreground)");
		urgent-background = lib.mkForce (mkLiteral           "var(urgent)");
		urgent-foreground = lib.mkForce (mkLiteral           "var(background)");
		active-background = lib.mkForce (mkLiteral           "var(active)");
		active-foreground = lib.mkForce (mkLiteral           "var(background)");
		selected-normal-background = lib.mkForce (mkLiteral  "var(selected)");
		selected-normal-foreground = lib.mkForce (mkLiteral  "var(background)");
		selected-urgent-background = lib.mkForce (mkLiteral  "var(active)");
		selected-urgent-foreground = lib.mkForce (mkLiteral  "var(background)");
		selected-active-background = lib.mkForce (mkLiteral  "var(urgent)");
		selected-active-foreground = lib.mkForce (mkLiteral  "var(background)");
		alternate-normal-background = lib.mkForce (mkLiteral "var(background)");
		alternate-normal-foreground = lib.mkForce (mkLiteral "var(foreground)");
		alternate-urgent-background = lib.mkForce (mkLiteral "var(urgent)");
		alternate-urgent-foreground = lib.mkForce (mkLiteral "var(background)");
		alternate-active-background = lib.mkForce (mkLiteral "var(active)");
		alternate-active-foreground = lib.mkForce (mkLiteral "var(background)");
		}
	];
    home-manager.users.${config.user.settings.username} = {config, osConfig, ...}: {


      config.programs.rofi = {
        theme = let
          inherit (config.lib.formats.rasi) mkLiteral;
          in {
          "*" = lib.mkForce (lib.foldl' lib.recursiveUpdate {} osConfig.theming.apps.rofi.starConfig);

		  	"configuration" = lib.mkForce {
				modi =                       "drun,run,filebrowser,window";
				show-icons =                 true;
				display-drun =               " Apps";
				display-run =                " Run";
				display-filebrowser =        " Files";
				display-window =             " Windows";
				drun-display-format =        "{name}";
				window-format =              "{w} · {c} · {t}";
			};

			"window" = lib.mkForce {
				/* properties for window widget */
				transparency =     	          "real";
				location = mkLiteral                   "center";
				anchor =   mkLiteral                   "center";
				fullscreen =                  false;
				width =  mkLiteral                     "800px";
				x-offset = mkLiteral                   "0px";
				y-offset =  mkLiteral                  "0px";

				/* properties for all widgets */
				enabled =                     true;
				margin = mkLiteral                     "0px";
				padding =  mkLiteral                   "0px";
				border =  mkLiteral                    "0px solid";
				border-radius = mkLiteral              "10px";
				border-color =  mkLiteral              "@border-colour";
				cursor =                      "default";
				/* Backgroud Colors */
				background-color = mkLiteral           "@background-colour";
			};

			"mainbox" = lib.mkForce {
				enabled =                     true;
				spacing =  mkLiteral                   "0px";
				margin = mkLiteral                     "0px";
				padding =  mkLiteral                   "20px";
				border =  mkLiteral                    "0px solid";
				border-radius = mkLiteral              "0px 0px 0px 0px";
				border-color =  mkLiteral              "@border-colour";
				background-color = mkLiteral           "transparent";
				children =  map mkLiteral              [ "inputbar" "message" "mode-switcher" "listview" ];
			};

			"inputbar" = lib.mkForce {
				enabled =                     true;
				spacing = mkLiteral                    "10px";
				margin =  mkLiteral                    "0px 0px 10px 0px";
				padding =  mkLiteral                   "5px 10px";
				border =  mkLiteral                    "0px solid";
				border-radius = mkLiteral              "10px";
				border-color =  mkLiteral              "@border-colour";
				background-color =  mkLiteral          "@alternate-background";
				text-color =  mkLiteral                "@foreground-colour";
				children =   map mkLiteral              [ "textbox-prompt-colon" "entry" ];
			};

			"prompt" = lib.mkForce {
				enabled =                     true;
				background-color = mkLiteral            "inherit";
				text-color =  mkLiteral                  "inherit";
			};

			"textbox-prompt-colon" = lib.mkForce {
				enabled =                     true;
				padding =    mkLiteral        "5px 0px";
				expand =                      false;
				str =                         "";
				background-color = mkLiteral           "inherit";
				text-color =      mkLiteral            "inherit";
			};
			"entry" = lib.mkForce {
				enabled =                     true;
				padding =  mkLiteral                   "5px 0px";
				background-color =  mkLiteral          "inherit";
				text-color =      mkLiteral            "inherit";
				cursor =         mkLiteral             "text";
				placeholder =                          "Search...";
				placeholder-color =  mkLiteral         "inherit";
			};

			"num-filtered-rows" = lib.mkForce {
				enabled =                     true;
				expand =                      false;
				background-color = mkLiteral           "inherit";
				text-color =      mkLiteral            "inherit";
			};
			"textbox-num-sep" = lib.mkForce {
				enabled =                     true;
				expand =                      false;
				str =                 "/";
				background-color =  mkLiteral          "inherit";
				text-color =      mkLiteral            "inherit";
			};

			"num-rows" = lib.mkForce {
				enabled =                     true;
				expand =                      false;
				background-color = mkLiteral           "inherit";
				text-color =      mkLiteral            "inherit";
			};
			"case-indicator" = lib.mkForce {
				enabled =                     true;
				background-color =      mkLiteral            "inherit";
				text-color =      mkLiteral            "inherit";
			};

			/*****----- Listview -----*****/
			"listview" = lib.mkForce {
				enabled =                     true;
				columns =                     1;
				lines =                       8;
				cycle =                       true;
				dynamic =                     true;
				scrollbar =                   false;
				layout =    mkLiteral                  "vertical";
				reverse =                     false;
				fixed-height =                true;
				fixed-columns =               true;
				
				spacing =  mkLiteral                   "5px";
				margin =                      mkLiteral                    "0px";
				padding =                     mkLiteral                   "10px";
				border =                      mkLiteral                    "0px 2px 2px 2px";
				border-radius =               mkLiteral              "0px 0px 10px 10px";
				border-color =                mkLiteral              "@border-colour";
				background-color = mkLiteral           "transparent";
				text-color =                  mkLiteral            "@foreground-colour";
				cursor =                      "default";
			};
			"scrollbar" = lib.mkForce {
				handle-width = mkLiteral               "5px";
				handle-color =                mkLiteral            "@handle-colour";
				border-radius =               mkLiteral              "10px";
				background-color =            mkLiteral            "@alternate-background";
			};

			/*****----- Elements -----*****/
			"element" = lib.mkForce {
				enabled =                     true;
				spacing =  mkLiteral                   "10px";
				margin =                      mkLiteral                    "0px";
				padding =                     mkLiteral                   "6px";
				border =                      mkLiteral                    "0px solid";
				border-radius =               mkLiteral              "6px";
				border-color =                mkLiteral              "@border-colour";
				background-color =            mkLiteral           "transparent";
				text-color =                  mkLiteral            "@foreground-colour";
				cursor =   mkLiteral                   "pointer";
			};

			"element normal.normal" = lib.mkForce {
				background-color =  mkLiteral          "var(normal-background)";
				text-color =                  mkLiteral            "var(normal-foreground)";
			};
			"element normal.urgent" = lib.mkForce {
				background-color =            mkLiteral            "var(urgent-background)";
				text-color =                  mkLiteral            "var(urgent-foreground)";
			};
			"element normal.active" = lib.mkForce {
				background-color =            mkLiteral            "var(active-background)";
				text-color =                  mkLiteral            "var(active-foreground)";
			};

			"element selected.normal" = lib.mkForce {
				background-color =            mkLiteral            "var(selected-normal-background)";
				text-color =                  mkLiteral            "var(selected-normal-foreground)";
			};
			"element selected.urgent" = lib.mkForce {
				background-color =            mkLiteral            "var(selected-urgent-background)";
				text-color =                  mkLiteral            "var(selected-urgent-foreground)";
			};
			"element selected.active" = lib.mkForce {
				background-color =            mkLiteral            "var(selected-active-background)";
				text-color =                  mkLiteral            "var(selected-active-foreground)";
			};

			"element alternate.normal" = lib.mkForce {
				background-color =            mkLiteral            "var(alternate-normal-background)";
				text-color =                  mkLiteral            "var(alternate-normal-foreground)";
			};
			"element alternate.urgent" = lib.mkForce {
				background-color =            mkLiteral            "var(alternate-urgent-background)";
				text-color =                  mkLiteral            "var(alternate-urgent-foreground)";
			};
			"element alternate.active" = lib.mkForce {
				background-color =            mkLiteral            "var(alternate-active-background)";
				text-color =                  mkLiteral            "var(alternate-active-foreground)";
			};
			"element-icon" = lib.mkForce {
				background-color =  mkLiteral          "transparent";
				text-color =       mkLiteral           "inherit";
				size =              mkLiteral          "24px";
				cursor =            mkLiteral          "inherit";
			};
			"element-text" = lib.mkForce {
				background-color =            mkLiteral          "transparent";
				text-color =                  mkLiteral           "inherit";
				highlight =                   mkLiteral           "inherit";
				cursor =                      mkLiteral           "inherit";
				vertical-align =              mkLiteral           "0.5";
				horizontal-align =            mkLiteral           "0.0";
			};

			/*****----- Mode Switcher -----*****/
			"mode-switcher" = lib.mkForce {
				enabled =                     true;
				expand =                      false;
				spacing = mkLiteral                    "0px";
				margin =                      mkLiteral                    "0px";
				padding =                     mkLiteral                    "0px";
				border =                      mkLiteral                    "0px solid";
				border-radius =               mkLiteral                    "0px";
				border-color =                mkLiteral                    "@border-colour";
				background-color =            mkLiteral                    "transparent";
				text-color =                  mkLiteral                    "@foreground-colour";
			};
			"button" = lib.mkForce {
				padding =                     mkLiteral                    "10px";
				border =                      mkLiteral                    "0px 0px 2px 0px";
				border-radius =               mkLiteral                    "10px 10px 0px 0px";
				border-color =                mkLiteral                    "@border-colour";
				background-color =            mkLiteral                    "@background-colour";
				text-color =                  mkLiteral                    "inherit";
				cursor =                      mkLiteral                    "pointer";
			};
			"button selected" = lib.mkForce {
				border =                      mkLiteral                    "2px 2px 0px 2px";
				border-radius =               mkLiteral                    "10px 10px 0px 0px";
				border-color =                mkLiteral                    "@border-colour";
				background-color =            mkLiteral                    "var(normal-background)";
				text-color =                  mkLiteral                    "var(normal-foreground)";
			};

			/*****----- Message -----*****/
			"message" = lib.mkForce {
				enabled =                     true;
				margin =   mkLiteral                   "0px 0px 10px 0px";
				padding =                     mkLiteral                    "0px";
				border =                      mkLiteral                    "0px solid";
				border-radius =               mkLiteral                    "0px 0px 0px 0px";
				border-color =                mkLiteral                    "@border-colour";
				background-color =            mkLiteral                    "transparent";
				text-color =                  mkLiteral                    "@foreground-colour";
			};
			"textbox" = lib.mkForce {
				padding =                     mkLiteral                    "10px";
				border =                      mkLiteral                    "0px solid";
				border-radius =               mkLiteral                    "10px";
				border-color =                mkLiteral                    "@border-colour";
				background-color =            mkLiteral                    "@alternate-background";
				text-color =                  mkLiteral                    "@foreground-colour";
				vertical-align =              mkLiteral           "0.5";
				horizontal-align =            mkLiteral           "0.0";
				highlight =         mkLiteral          "none";
				placeholder-color =           mkLiteral                    "@foreground-colour";
				blink =                       true;
				markup =                      true;
			};
			"error-message" = lib.mkForce {
				padding =                     mkLiteral                    "10px";
				border =                      mkLiteral                    "2px solid";
				border-radius =               mkLiteral                    "10px";
				border-color =                mkLiteral                    "@border-colour";
				background-color =            mkLiteral                    "@background-colour";
				text-color =                  mkLiteral                    "@foreground-colour";
			};

			"sidebar" = lib.mkForce {
			};
        };
      }; 
    };
  };
}