
{ config, lib, ... }:
let
	defaultApps = config.packages.defaults;
in
{

	config = {
		environment.sessionVariables = {
			TERMINAL = defaultApps.terminal.active;
		};



		home-manager.users.${config.user.settings.username} = {
			#TODO

			home.sessionVariables = {
				EDITOR = defaultApps.editor.active;
				TERM = defaultApps.terminal.active;
			
			};


			xdg.mimeApps = {
				enable = true;
				defaultApplications = {

					"application/pdf" 			= defaultApps.browser.appID;
					"x-scheme-handler/http" 	= defaultApps.browser.appID;
		      		"x-scheme-handler/https" 	= defaultApps.browser.appID;
					"x-scheme-handler/about" 	= defaultApps.browser.appID;
					"x-scheme-handler/unknown" 	= defaultApps.browser.appID;

					"text/html" 				= defaultApps.editor.appID;
					"text/plain"				= defaultApps.editor.appID;
					"text/markdown"				= defaultApps.editor.appID;
					"application/json"			= defaultApps.editor.appID;
					"application/xml"			= defaultApps.editor.appID;
					"application/javascript"	= defaultApps.editor.appID;

					#"image/png"				=...
					#"image/jpeg"				=...
					#"image/gif"				=...

					#"audio/mpeg"				=...
					#"audio/flac"				=...

					#"video/mp4"				=...
					#"video/webm"				=...

					"application/zip"			= "org.gnome.ArchiveManager.desktop";
					"application/x-tar"			= "org.gnome.ArchiveManager.desktop";

					"inode/directory"			= defaultApps.explorer.appID;

					"x-scheme-handler/terminal"	= defaultApps.terminal.appID;


					/*
					"text/html" = editorSettings.gnomeAppName;
					"x-scheme-handler/http" = browserSettings.gnomeAppName;
		      			"x-scheme-handler/https" = browserSettings.gnomeAppName;
					"x-scheme-handler/about" = browserSettings.gnomeAppName;
					"x-scheme-handler/unknown" = browserSettings.gnomeAppName;
					"inode/directory" = [ explorerSettings.gnomeAppName ];
					"x-scheme-handler/terminal" = [ terminalSettings.gnomeAppName ];
					*/
				};
			};
		};

	};
} 
