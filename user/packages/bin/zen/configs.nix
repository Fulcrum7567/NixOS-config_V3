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
					};
					pinsForce = true;
					pins = {
						"Moodle" = {
							url = "https://lms.fh-wedel.de/my/courses.php";
							id = "8499796c-d322-4713-af65-b13da909e538";
							container = 2;
							workspace = "a7f9811e-2bb5-4e4f-ad7b-f32a1eee19c4";
							position = 1;
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
							position = 2;
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
							position = 3;
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
							position = 4;
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
