{ config, lib, settings, inputs, pkgs-default, pkgs-stable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "vesktop")) {


		home-manager.users.${config.user.settings.username} = {
			programs.nixcord = {
				vesktop = {
					enable = true;
					package = pkgs-stable.vesktop.overrideAttrs (prev: {
						desktopItems = [
							(pkgs-stable.makeDesktopItem {
								name = "discord";
								desktopName = "Discord";
								exec = "vesktop %U";
								icon = ../../shared/discord-icon.svg;
								startupWMClass = "vesktop";
								genericName = "Internet Messenger";
								keywords = [
									"discord"
									"vencord"
									"vesktop"
									"nixcord"
								];
							})
						];
					});
				};
				discord.enable = false;
				config = {
					useQuickCss = true;
					themeLinks = [
						# "https://refact0r.github.io/midnight-discord/build/midnight.css"
						"https://github.com/refact0r/midnight-discord/blob/master/themes/flavors/midnight-nord.theme.css"
					];

					enabledThemes = [
						"midnight-nord"
					];

					frameless = true;

					plugins = {
						alwaysAnimate.enable = true;
						betterFolders = {
							enable = false;
							closeAllFolders = true;
							closeAllHomeButton = true;
							closeOthers = true;
							forceOpen = true;
						};
						betterSessions.enable = false;
						betterSettings.enable = true;
						callTimer.enable = true;
						copyFileContents.enable = true;
						customIdle = {
							enable = true;
							idleTimeout = 5.0;
							remainInIdle = true;
						};
						disableCallIdle.enable = true;
						experiments.enable = true;
						fakeNitro = {
							enable = true;
							enableEmojiBypass = false;
							enableStickerBypass = false;
							enableStreamQualityBypass = true;
						};
						favoriteEmojiFirst.enable = true;
						friendsSince.enable = true;
						gameActivityToggle.enable = true;
						implicitRelationships.enable = true;
						newGuildSettings = {
							enable = true;
							guild = true;
							events = true;
							everyone = true;
							highlights = true;
							messages = 2;
							mobilePush = true;
							role = true;
							showAllChannels = true;
							voiceChannels = true;
						};
						noOnboardingDelay.enable = true;
						noPendingCount = {
							enable = true;
							hideFriendRequestsCount = false;
							hideMessageRequestsCount = false;
							hidePremiumOffersCount = true;
						};
						noProfileThemes.enable = true;
						oneko.enable = true;
						platformIndicators.enable = true;
						secretRingToneEnabler.enable = false;
						summaries.enable = true;
						serverListIndicators = {
							enable = true;
							mode = 3;
						};
						userVoiceShow.enable = true;
						volumeBooster = {
							enable = true;
							multiplier = 3.0;
						};
					};
				};

				userPlugins = {
					#notifyUserChanges = "github:D3SOX/vc-notifyUserChanges/4b36010991c762581bc941ed0e74b42989f584e7";
					#hideUsers = "github:SpiderUnderUrBed/hideUsers/beec09944f5b7e516fd9e5baec734739f83ec2b2";
					#betterActivities = "github:D3SOX/vc-betterActivities/044b504666b8b753ab45d82c0cd0d316b1ea7e60";
				};

				extraConfig = {
					SKIP_HOST_UPDATE = true;
					#notifyUserChanges.enable = false;
					#hideUsers.enable = true;
					#betterActivities.enable = true;
				};


		    	
			};
		};


	};
} 
