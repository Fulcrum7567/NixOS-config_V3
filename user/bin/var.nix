
{ config, ... }:
let
	defaultApps = config.packages.defaults;
in
{
	home-manager.users.${config.user.settings.username} = { ... }: {
		#TODO

		home.sessionVariables = {
			EDITOR = defaultApps.editor.active;
			TERM = defaultApps.terminal.active;
		
		};

		xdg.mimeApps = {
			enable = true;
			defaultApplications = {

				"application/pdf" 			= defaultApps.browser.active;
				"x-scheme-handler/http" 	= defaultApps.browser.active;
	      		"x-scheme-handler/https" 	= defaultApps.browser.active;
				"x-scheme-handler/about" 	= defaultApps.browser.active;
				"x-scheme-handler/unknown" 	= defaultApps.browser.active;

				"text/html" 				= defaultApps.editor.active;
				"text/plain"				= defaultApps.editor.active;
				"text/markdown"				= defaultApps.editor.active;
				"application/json"			= defaultApps.editor.active;
				"application/xml"			= defaultApps.editor.active;
				"application/javascript"	= defaultApps.editor.active;

				#"image/png"				=...
				#"image/jpeg"				=...
				#"image/gif"				=...

				#"audio/mpeg"				=...
				#"audio/flac"				=...

				#"video/mp4"				=...
				#"video/webm"				=...

				"application/zip"			= "org.gnome.ArchiveManager.desktop";
				"application/x-tar"			= "org.gnome.ArchiveManager.desktop";

				"inode/directory"			= defaultApps.explorer.active;

				"x-scheme-handler/terminal"	= defaultApps.terminal.active;


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
} 
