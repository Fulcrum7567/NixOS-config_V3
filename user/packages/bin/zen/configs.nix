{ config, lib, ... }:
{
	config = lib.mkIf config.packages.zen.enable {

		system.inputUpdates = [ "zen-browser-stable" "zen-browser-unstable" ];

		home-manager.users.${config.user.settings.username} = {
			programs.zen-browser = {
				enable = true;

				policies = let
					mkLockedAttrs = builtins.mapAttrs (_: value: {
						Value = value;
						Status = "locked";
					});
					mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
						installation_mode = "force_installed";
					});
				in {
					AppAutoUpdate = false;
					AutoFillAddressEnabled = true;
					AutoFillCreditCardEnabled = false;
					BlockAboutAddons = false;
					BlockAboutConfig = false;
					BlockAboutProfiles = false;
					BlockAboutSupport = false;
					ContentAnalysis = false;
					DisableAppUpdate = true;
					DisableBuiltinPDFViewer = false;
					DisableDeveloperTools = false;
					DisableFeedbackCommands = true;
					DisableFirefoxAccounts = true;
					DisableFirefoxScreenshots = false;
					DisableFirefoxStudies = false;
					DisableFormHistory = false;
					DisablePrivateBrowsing = false;
					DisableProfileImport = true;
					DisableSafeMode = false;
					DisableSecurityBypass = true;
					DisableSetDesktopBackground = true;
					DisableTelemetry = true;
					DisplayBookmarksToolbar = false;
					DisplayMenuBar = false;
					DontCheckDefaultBrowser = true;
					DownloadDirectory = "/home/${config.user.settings.username}/Downloads";
					EnableTrackingProtection = {
						Value = true;
						Locked = true;
						Cryptomining = true;
						Fingerprinting = true;
					};
					ManualAppUpdateOnly = true;
					NoDefaultBookmarks = true;
					OfferToSaveLogins = false;
					HardwareAcceleration = true;
					PictureInPicture.Enabled = true;
					PopUpBlocking = {
						Allow = [];
						Default = true;
						Locked = false;
					};

					SearchEngines = {
						Add = [
							{
								Name = "Google";
								URLTemplate = "https://www.google.com/search?q={searchTerms}";
								IconURL = "https://www.google.com/favicon.ico";
								Alias = "g";
							}
							{
								Name = "NixOS Search";
								URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
								IconURL = "https://nixos.org/favicon.ico";
								Alias = "n";
							}
							{
								Name = "MyNixOS Search";
								URLTemplate = "https://mynixos.com/search?q={searchTerms}";
								IconURL = "https://mynixos.com/favicon.ico";
								Alias = "mn";
							}
						];
						Default = "Google";
						Remove = [
							"Bing"
							"DuckDuckGo"
							"Ecosia"
							"Amazon.com"
							"Wikipedia (en)"
						];
					};

					SearchSuggestEnabled = true;
					ShowHomeButton = false;
					SkipTermsOfUse = true;
					StartDownloadsInTempDirectory = true;
					TranslateEnabled = false;

					UserMessaging = {
						ExtensionRecommendations = false;
						FeatureRecommendations = true;
						UrlbarInterventions = false;
						SkipOnboarding = true;
						MoreFromMozilla = false;
						FirefoxLabs = false;
						Locked = true;
					};

					Preferences = mkLockedAttrs {
						"browser.tabs.warnOnClose" = false;
						"zen.workspaces.continue-where-left-off" = true;
						"zen.workspaces.hide-default-container-indicator" = true;
						"zen.workspaces.open-new-tab-if-last-unpinned-tab-is-closed" = true;
						"zen.workspaces.separate-essentials" = true;
						"zen.workspaces.swipe-actions" = true;
						"zen.workspaces.wrap-around-navigation" = true;
						"browser.ctrlTab.sortByRecentlyUsed" = true;
						"browser.startup.page" = 3;
						"browser.link.open_newwindow" = 3;
						"browser.tabs.loadInBackground" = true;
						"accessibility.typeaheadfind" = true;
						"general.autoScroll" = true;
						"media.videocontrols.picture-in-picture.enabled" = true;
						"media.hardwaremediakeys.enabled" = true;
						"browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
						"extensions.htmlaboutaddons.recommendations.enabled" = false;
						"zen.view.use-single-toolbar" = false;
						"zen.welcome-screen.seen" = true;
						"zen.view.compact.enable-at-startup" = true;
						"zen.view.compact.hide-toolbar" = true;
						"zen.view.compact.toolbar-flash-popup" = true;
						"zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url" = true;
						"zen.urlbar.behavior" = "float";
						"zen.view.show-newtab-button-top" = false;
					};


					ExtensionSettings = mkExtensionSettings {
						"{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
						"addon@darkreader.org" = "darkreader";
						"{84c8edb0-65ca-43a5-bc53-0e80f41486e1}" = "tweaks-for-youtube";
						"{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
						"sponsorBlocker@ajay.app" = "sponsorblock";
						"uBlock0@raymondhill.net" = "ublock-origin";
						"myallychou@gmail.com" = "youtube-recommended-videos";
						"{6ea0a676-b3ef-48aa-b23d-24c8876945fb}" = "w2g";
						"jid1-KKzOGWgsW3Ao4Q@jetpack" = "i-dont-care-about-cookies";
					};
				};

				profiles."default" = let 
					tweaksForYouTubeSettings = builtins.fromJSON (
						builtins.readFile ./extensionSettings/tweaks-for-youtube.json
					);	
				in {
					containersForce = true;
					containers = {
						Private = {
							color = "turquoise";
							icon = "fingerprint";
							id = 1;
						};
						FH = {
							color = "red";
							icon = "briefcase";
							id = 2;
						};
						NixOS = {
							color = "blue";
							icon = "circle";
							id = 3;
						};

						Jasmin = {
							color = "pink";
							icon = "food";
							id = 4;
						};
					};

					spacesForce = true;
					spaces = {
						"Private" = {
							id = "2d19d9e4-c7c3-4260-a46d-b3b8dab8db24";
							icon = "🏡";
							container = 1;
							position = 1000;
						};
						"FH" = {
							id = "a7f9811e-2bb5-4e4f-ad7b-f32a1eee19c4";
							icon = "💼";
							container = 2;
							position = 2000;
						};
						"NixOS" = {
							id = "d99d79ca-e944-4d4f-9bd3-5965af61fb16";
							icon = "❄️";
							container = 3;
							position = 3000;
						};
						"Jasmin" = {
							id = "5c3fd124-d39d-420a-8989-f98fb0a7a47a";
							icon = "🌸";
							container = 4;
							position = 4000;
						};
					};
					pinsForce = true;
					pins = {

						# Private Workspace

						"YouTube" = {
							url = null;
							id = "2152852a-d575-4b8f-925f-ca6d63dc35b8";
							container = 1;
							workspace = "2d19d9e4-c7c3-4260-a46d-b3b8dab8db24";
							position = 1;
							isEssential = false;
							isGroup = true;
							editedTitle = true;
							isFolderCollapsed = true;
							folderIcon = "https://cdn3.iconfinder.com/data/icons/social-network-30/512/social-06-512.png";
							folderParentId = null;
						};

						"Subscriptions - YouTube" = {
							url = "https://www.youtube.com/feed/subscriptions";
							id = "d2ce3076-1192-4b73-9651-8de2375062af";
							container = 1;
							workspace = "2d19d9e4-c7c3-4260-a46d-b3b8dab8db24";
							position = 2;
							isEssential = false;
							isGroup = false;
							editedTitle = true;
							isFolderCollapsed = false;
							folderIcon = null;
							folderParentId = "2152852a-d575-4b8f-925f-ca6d63dc35b8";
						};

						"Watch Later - YouTube" = {
							url = "https://www.youtube.com/playlist?list=WL";
							id = "c837024b-3350-42cf-bf26-09d6ea06b0fd";
							container = 1;
							workspace = "2d19d9e4-c7c3-4260-a46d-b3b8dab8db24";
							position = 3;
							isEssential = false;
							isGroup = false;
							editedTitle = true;
							isFolderCollapsed = false;
							folderIcon = null;
							folderParentId = "2152852a-d575-4b8f-925f-ca6d63dc35b8";
						};

						"Mit Jasmin - Youtube" = {
							url = "https://www.youtube.com/playlist?list=PLCG25QW23viB4NajkNTjQjfRaojO0Z83f";
							id = "6de41e06-ac37-49c2-9508-21e06eee1b0a";
							container = 1;
							workspace = "2d19d9e4-c7c3-4260-a46d-b3b8dab8db24";
							position = 4;
							isEssential = false;
							isGroup = false;
							editedTitle = true;
							isFolderCollapsed = false;
							folderIcon = null;
							folderParentId = "2152852a-d575-4b8f-925f-ca6d63dc35b8";
						};


						"Watch2Gether" = {
							url = "https://w2g.tv/en/room/?access_key=b3zw0q715qpmfzxo0j10ob";
							id = "8f3f3f3e-5b6d-4c2a-9f4e-8e2b8f3c3d4e";
							container = 1;
							workspace = "2d19d9e4-c7c3-4260-a46d-b3b8dab8db24";
							position = 5;
							isEssential = false;
							isGroup = false;
							editedTitle = true;
							isFolderCollapsed = false;
							folderIcon = null;
							folderParentId = "2152852a-d575-4b8f-925f-ca6d63dc35b8";
						};


						"GitHub" = {
							url = "https://github.com/fulcrum7567";
							id = "e086904a-184c-4f61-9895-433ad8416e60";
							container = 1;
							workspace = "2d19d9e4-c7c3-4260-a46d-b3b8dab8db24";
							position = 6;
							isEssential = false;
							isGroup = false;
							editedTitle = true;
							isFolderCollapsed = false;
							folderIcon = null;
							folderParentId = null;
						};

						# FH Workspace

						"Moodle" = {
							url = "https://lms.fh-wedel.de/my/courses.php";
							id = "8499796c-d322-4713-af65-b13da909e538";
							container = 2;
							workspace = "a7f9811e-2bb5-4e4f-ad7b-f32a1eee19c4";
							position = 10;
							isEssential = false;
							isGroup = false;
							editedTitle = true;
							isFolderCollapsed = false;
							folderIcon = null;
							folderParentId = null;
						};

						"myCampus" = {
							url = "https://mycampus.fh-wedel.de/campus/#!app/smartdesign.campus.studyplanco";
							id = "0a22945c-291d-47f1-8030-a14f608f6e5a";
							container = 2;
							workspace = "a7f9811e-2bb5-4e4f-ad7b-f32a1eee19c4";
							position = 20;
							isEssential = false;
							isGroup = false;
							editedTitle = true;
							isFolderCollapsed = false;
							folderIcon = null;
							folderParentId = null;
						};

						"Teams" = {
							url = "https://teams.microsoft.com/v2/";
							id = "ad777a60-36c5-4eed-9d19-ec3a0b08f7c8";
							container = 2;
							workspace = "a7f9811e-2bb5-4e4f-ad7b-f32a1eee19c4";
							position = 30;
							isEssential = false;
							isGroup = false;
							editedTitle = true;
							isFolderCollapsed = false;
							folderIcon = null;
							folderParentId = null;
						};

						"Outlook" = {
							url = "https://outlook.office.com/mail/0/?deeplink=mail%2F0%2F%3Fnlp%3D0";
							id = "1fcbc314-55ac-4021-97a1-72bcda0d4a33";
							container = 2;
							workspace = "a7f9811e-2bb5-4e4f-ad7b-f32a1eee19c4";
							position = 40;
							isEssential = false;
							isGroup = false;
							editedTitle = true;
							isFolderCollapsed = false;
							folderIcon = null;
							folderParentId = null;
						};

						"Dualer Kalender" = {
							url = "https://www.fh-wedel.de/fileadmin/FHW-Files/Dokumente_FHW/Dual/Dualer_Kalender_FH_Wedel_6-1__SomS25-SomS26__v2.03_25-10-16.pdf";
							id = "a46f7594-0c26-45fa-b41f-bd19277dc28d";
							container = 2;
							workspace = "a7f9811e-2bb5-4e4f-ad7b-f32a1eee19c4";
							position = 50;
							isEssential = false;
							isGroup = false;
							editedTitle = true;
							isFolderCollapsed = false;
							folderIcon = null;
							folderParentId = null;
						};

						"Handout-Server" = {
							url = "https://stud.fh-wedel.de/handout/";
							id = "b01b88f8-d8cf-480b-b61a-3b5af22c4cd6";
							container = 2;
							workspace = "a7f9811e-2bb5-4e4f-ad7b-f32a1eee19c4";
							position = 60;
							isEssential = false;
							isGroup = false;
							editedTitle = true;
							isFolderCollapsed = false;
							folderIcon = null;
							folderParentId = null;
						};

						"Zeiterfassung SP Abnahme" = {
							url = "https://rzfhwedel-my.sharepoint.com/:x:/r/personal/avh_rz_fh-wedel_de/_layouts/15/Doc.aspx?sourcedoc={6D5FA4B1-D905-4A6E-A2D8-09AD8F23631A}&file=Zeiterfassung_WS2526_SP_Mario.xlsx&fromShare=true&action=default&mobileredirect=true";
							id = "f66afbd5-d320-4476-a9fd-7504566469cd";
							container = 2;
							workspace = "a7f9811e-2bb5-4e4f-ad7b-f32a1eee19c4";
							position = 70;
							isEssential = false;
							isGroup = false;
							editedTitle = true;
							isFolderCollapsed = false;
							folderIcon = null;
							folderParentId = null;
						};

						"SP Testserver" = {
							url = "https://sp.fh-wedel.de:4434/fhw";
							id = "d0608699-9467-4c56-a5f9-c4a2dcf3e566";
							container = 2;
							workspace = "a7f9811e-2bb5-4e4f-ad7b-f32a1eee19c4";
							position = 80;
							isEssential = false;
							isGroup = false;
							editedTitle = true;
							isFolderCollapsed = false;
							folderIcon = null;
							folderParentId = null;
						};

						# NixOS Workspace

						".dotfiles - GitHub" = {
							url = "https://github.com/Fulcrum7567/NixOS-config_V3";
							id ="ce010016-b97b-452d-a4a9-7850b92f0948";
							container = 3;
							workspace = "d99d79ca-e944-4d4f-9bd3-5965af61fb16";
							position = 1;
							isEssential = false;
							isGroup = false;
							editedTitle = true;
							isFolderCollapsed = false;
							folderIcon = null;
							folderParentId = null;
						};
					};


					settings = {
						"browser.tabs.warnOnClose" = false;
						"zen.workspaces.continue-where-left-off" = true;
						"zen.workspaces.hide-default-container-indicator" = true;
						"zen.workspaces.open-new-tab-if-last-unpinned-tab-is-closed" = true;
						"zen.workspaces.separate-essentials" = true;
						"zen.workspaces.swipe-actions" = true;
						"zen.workspaces.wrap-around-navigation" = true;
						"browser.ctrlTab.sortByRecentlyUsed" = true;
						"browser.startup.page" = 3;
						"browser.link.open_newwindow" = 3;
						"browser.tabs.loadInBackground" = true;
						"accessibility.typeaheadfind" = true;
						"general.autoScroll" = true;
						"media.videocontrols.picture-in-picture.enabled" = true;
						"media.hardwaremediakeys.enabled" = true;
						"browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
						"extensions.htmlaboutaddons.recommendations.enabled" = false;
						"zen.view.use-single-toolbar" = false;
						"zen.welcome-screen.seen" = true;
						"zen.view.compact.enable-at-startup" = true;
						"zen.view.compact.hide-toolbar" = true;
						"zen.view.compact.toolbar-flash-popup" = true;
						"zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url" = true;
						"zen.urlbar.behavior" = "float";
						"zen.view.show-newtab-button-top" = false;
					};

					/*
					extraConfig = ''
						// Tweaks for YouTube extension settings
						user_pref("4029d517-679b-443b-b6cb-a44d502bbee4.settings", ${builtins.toJSON tweaksForYouTubeSettings});
					'';
					*/

					
				};
			};
		};
	};
} 
