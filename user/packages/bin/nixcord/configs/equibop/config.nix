{ config, lib, settings, inputs, pkgs-default, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "equibop")) {


		home-manager.users.${config.user.settings.username} = {
			programs.nixcord = {
				discord.enable = false;

				equibop = {
					enable = true;
					package = pkgs-default.equibop.overrideAttrs (prev: {
						desktopItems = [
							(pkgs-default.makeDesktopItem {
								name = "discord";
								desktopName = "Discord";
								exec = "equibop %U";
								icon = ../../shared/discord-icon.svg;
								startupWMClass = "equibop";
								genericName = "Internet Messenger";
								keywords = [
									"discord"
									"vencord"
									"equibop"
									"nixcord"
								];
							})
						];
					});

					settings = {

					};
				};

				config = {

					frameless = true;

					

					plugins = {

						# equicord-only plugins
						
						allCallTimers = {
							enable = true;
							format = "stopwatch"; # "stopwatch" or "human"
							showRoleColor = true;
							showSeconds = true;
							showWithoutHover = true;
							trackSelf = true;
							watchLargeGuilds = false; # lags
						};

						altKrispSwitch.enable = true;
						alwaysExpandProfiles.enable = false;
						amITyping.enable = true;

						anammox = {
							enable = true;
							billing = true;
							dms = true;
							emojiList = true;
							gift = true;
							serverBoost = true;
						};

						animalese = {
							enable = false;
						};

						arRpcBun.enable = false;
						atSomeone.enable = false;
						
						audioBookShelfRichPresence = {
							enable = false;
						};

						autoZipper = {
							enable = true;
						};

						bannersEverywhere = {
							enable = true;
							animate = true;
							preferNameplate = false;
						};

						betterActivities.enable = true;

						betterAudioPlayer = {
							enable = false;
						};

						betterBanReasons.enable = false;
						betterBlockedUsers.enable = false;
						betterCommands.enable = false;
						betterInvites.enable = false;
						betterPlusReacts.enable = false;

						betterQuickReact = {
							enable = true;
							columns = 4.0;
							rows = 2.0;
							compactMode = false;
							frequentEmojis = true;
							scroll = true;
						};

						blockKeywords.enable = false;
						blockKrisp.enable = false;
						bypassPinPrompt.enable = true;
						bypassStatus.enable = false;
						channelBadges.enable = false;
						channelTabs.enable = true;

						characterCounter = {
							enable = false;
							colorEffects = true;
						};

						cleanChannelName.enable = false;
						cleanUserArea.enable = true;
						
						clientSideBlock = {
							enable = true;
							blockedReplyDisplay = "displayText"; # "displayText" | "hideReply"
							guildBlackList = "";
							guildWhiteList = "";
							hideBlockedMessages = true;
							hideBlockedUsers = true;
							hideEmptyRoles = true;
							usersToBlock = ""; # separate by comma + space
						};

						clipsEnhancements = {
							enable = false;
						};

						commandPalette = {
							enable = false;
						};

						contentWarning = {
							enable = false;
						};

						copyProfileColors.enable = false;
						copyStatusUrls.enable = false;
						copyUserMention.enable = false;
						customFolderIcons.enable = false;

						customSounds = {
							enable = false;
							overrides = {};
						};

						customTimestamps = {
							enable = false;
							formats = {};
						};

						customUserColors = {
							enable = false;
							colorInServers = true;
							dmList = true;
						};

						decodeBase64 = {
							enable = false;
							clickMethod = "left"; # "left" | "right"
						};

						disableCameras.enable = false;
						discordDevBanner.enable = false;
						dontFilterMe.enable = false;

						equicordHelper = {
							enable = false;
							disableCreateDmButton = false;
							disableDmContextMenu = false;
							noMirroredCamera = false;
							removeActivitySection = false;
						};

						equicordToolbox.enable = false;

						equissant = {
							enable = false;
							amount = 10;
						};

						exportMessages = {
							enable = false;
							exportContacts = false;
							openFileAfterExport = false;
						};

						fastDeleteChannels = {
							enable = false;
						};

						findReply = {
							enable = false;
						};

						fixFileExtensions.enable = false;

						followVoiceUser = {
							enable = false;
						};

						fontLoader = {
							enable = false;
						};

						forwardAnywhere = {
							enable = false;
						};

						frequentQuickSwitcher.enable = false;
						friendCloud.enable = false;
						friendCodes.enable = false;

						friendTags = {
							enable = false;
						};

						friendshipRanks.enable = true;
						fullVcpfp.enable = false;

						gensokyoRadioRpc = {
							enable = false;
						};

						ghosted = {
							enable = true;
							exemptedChannels = ""; # comma separated channel IDs
							scary = false;
							showDmIcons = true;
							showIndicator = true;
						};

						gifCollections = {
							enable = false;
						};

						gifRoulette = {
							enable = false;
						};

						gitHubRepos = {
							enable = true;
							showInMiniProfile = true;
							showLanguage = true;
							showStars = true;
						};

						globalBadges = {
							enable = false;
						};

						googleThat = {
							enable = false;
						};

						guildPickerDumper.enable = false;

						guildTagSettings = {
							enable = true;
							disableAdoptTagPrompt = true;
							hideTags = true;
						};

						hideChatButtons = {
							enable = false;
						};

						hideServers.enable = false;
						holyNotes.enable = false;
						homeTyping.enable = true;

						hopOn = {
							enable = false;
						};

						husk = {
							enable = false;
						};

						iRememberYou.enable = false;
						iconViewer.enable = false;
						
						ignoreCalls = {
							enable = false;
							permanentlyIgnoredUsers = ""; # comma separated user IDs
						};

						ignoreTerms.enable = true;
						imgToGif.enable = false;
						inRole.enable = false;
						
						ingtoninator = {
							enable = false;
						};

						instantScreenshare.enable = false;

						inviteDefaults = {
							enable = false;
						};

						jellyfinRichPresence = {
							enable = true;
							apiKey = null;
							coverType = "series"; # "series" | "episode"
							customName = null; #Custom Rich Presence name (only used if 'Custom' is selected). Options: {name}, {series}, {season}, {episode}, {artist}, {album}, {year}'';
							episodeFormat = "long"; # "long" | "short" | "fulltext"
							nameDisplay = "default"; # "default" | "full" | "custom"
							overrideRichPresenceType = false; # false, 2, 0, 1, 3
							privacyMode = false;
							serverUrl = null;
							showEpisodeName = false;
							showPausedState = true;
							showTmdbButton = true;
							userId = null;
						};

						jumpTo.enable = false;

						jumpscare = {
							enable = false;
						};

						keyboardNavigation = {
							enable = false;
						};

						keyboardSounds = {
							enable = true;
							soundPack = "osu"; # "osu" | "operagx"
							volume = 100.0;
						};

						keywordNotify = {
							enable = false;
						};

						lastActive.enable = false;

						limitMiddleClickPaste = {
							enable = false;
						};

						listenBrainzRpc = {
							enable = false;
						};

						loginWithQr = {
							enable = false;
						};

						mediaPlaybackSpeed = {
							enable = false;
						};

						messageBurst = {
							enable = false;
						};

						messageColors.enable = true;

						messageFetchTimer = {
							enable = false;
						};

						messageLinkTooltip = {
							enable = false;
						};

						messageLoggerEnhanced.enable = false;

						messageTranslate = {
							enable = false;
						};

						moreCommands.enable = false;
						moreKaomoji.enable = false;

						moreStickers = {
							enable = false;
							packs = {};
						};

						moreUserTags.enable = false;

						moyai = {
							enable = false;
						};

						musicControls.enable = false;
						neverPausePreviews.enable = false;
						newPluginsManager.enable = true;
						noBulletPoints.enable = false;
						noModalAnimation.enable = true;
						noNitroUpsell.enable = true;
						noOnboarding.enable = true;
						noRoleHeaders.enable = false;
						noRpc.enable = false;
						notificationTitle.enable = true;

						orbolayBridge = {
							enable = false;
						};

						partyMode = {
							enable = false;
						};

						pinIcon.enable = true;

						pingNotifications = {
							enable = false;
						};

						platformSpoofer = {
							enable = true;
							platform = "desktop"; # "desktop" | "web" | "android" | "ios" "xbox" | "playstation"
						};

						polishWording = {
							enable = false;
						};

						questCompleter = {
							enable = false;
						};

						questFocused.enable = false;
						questify.enable = false;

						questingMarkReplacement = {
							enable = false;
						};

						quickThemeSwitcher = {
							enable = false;
							autoRefresh = true;
							includeLocal = true;
							includeOnline = true;
							showNotifications = true;
							sortOrder = "alphabetical"; # "alphabetical" | "reverse" | "recent"
						};

						quoter = {
							enable = false;
						};

						randomVoice = {
							enable = false;
						};

						recentDmSwitcher = {
							enable = true;
							amountOfUsers = 20.0;
							clearRdms = {};
							overlayMode = "row"; # "row" | "current"
							overlayRowLength = 5.0;
							overlayShowAvatars = true;
							toastDurationMs = 600.0;
							visualStyle = "overlay"; # "overlay" | "toast" | "off"
						};

						remixRevived.enable = false;

						replyPingControl = {
							enable = false;
						};

						rpcEditor = {
							enable = false;
						};

						rpcStats = {
							enable = false;
						};

						saveFavoriteGifs.enable = false;
						screenRecorder.enable = false;
						searchFix.enable = false;

						sekaiStickers = {
							enable = false;
						};

						selfForward.enable = false;
						serverSearch.enable = false;
						showBadgesInChat.enable = false;
						showMessageEmbeds.enable = false;
						showResourceChannels.enable = true;
						sidebarChat.enable = true;

						signature = {
							enable = false;
						};

						snowfall = {
							enable = true;
							flakesPerSecond = 5.0;
							maxSize = 30.0;
							speed = 50.0;
							typeOfSnow = "text"; # "solid" | "text" | "image"
						};

						soggy = {
							enable = false;
						};

						songLink = {
							enable = false;
						};

						soundBoardLogger.enable = false;

						splitLargeMessages = {
							enable = false;
						};

						spotifyActivityToggle.enable = false;

						statsfmPresence = {
							enable = true;
							alwaysHideArt = false;
							hideWithExternalRpc = true;
							hideWithSpotify = false;
							missingArt = "StatsFmLogo"; # "StatsFmLogo" | "placeholder"
							nameFormat = "status-name"; #"status-name" | "artist-first" | "song-first" | "artist" | "song" |"albums"
							shareSong = true;
							shareUsername = false;
							showStatsFmLogo = true;
							statusName = "Stats.fm";
							useListeningStatus = true;
							username = null;
						};

						statusPresets = {
							enable = false;
						};

						statusWhileActive = {
							enable = false;
						};

						steamStatusSync = {
							enable = false;
						};

						stickerBlocker = {
							enable = false;
						};

						streamingCodecDisabler = {
							enable = false;
						};

						talkInReverse.enable = false;
						themeLibrary.enable = true;
						tidalEmbeds.enable = false;
						tiktokTts.enable = false;
						
						timelessClips = {
							enable = false;
						};

						timezones = {
							enable = false;
						};

						title = {
							enable = true;
							title = "${config.user.settings.username}'s Discord";
						};

						toastNotifications =  {
							enable = true;
							determineServerNotifications = true;
							directMessages = true;
							disableInStreamerMode = true;
							exampleButton = {};
							friendActivity = true;
							friendServerNotifications = true;
							groupMessages = true;
							ignoreUsers = "";
							maxNotifications = 3.0;
							notifyFor = "";
							opacity = 85.0;
							position = "top-right"; # "top-right" | "top-left" | "bottom-right" | "bottom-left"
							renderImages = true;
							streamingTreatment = 0;
							timeout = 5.0;
						};

						toggleVideoBind = {
							enable = false;
						};

						toneIndicators = {
							enable = false;
						};

						tosuRpc.enable = false;

						translate = {
							enable = false;
						};

						unitConverter = {
							enable = false;
						};

						universalMention = {
							enable = false;
						};

						unlimitedAccounts = {
							enable = false;
						};

						unreadCountBadge = {
							enable = false;
						};

						userPfp = {
							enable = true;
							preferNitro = true;
						};

						vcNarratorCustom = {
							enable = false;
						};

						vcPanelSettings = {
							enable = false;
						};

						vcSupport.enable = false;

						videoSpeed = {
							enable = false;
						};

						viewRawVariant.enable = false;

						voiceButtons = {
							enable = false;
						};

						voiceChannelLog = {
							enable = true;
							ignoreBlockedUsers = true;
							mode = 1;
							voiceChannelChatSelf = true;
							voicChannelChatSilent = true;
							voiceChannelChatSilentSelf = false;
						};

						voiceChatUtilities = {
							enable = false;
						};

						voiceJoinMessages = {
							enable = true;
							allowedFriends = "";
							friendDirectMessages = true;
							friendDirectMessagesSelf = false;
							friendDirectMessagesShowMemberCount = false;
							friendDirectMessagesShowMembers = true;
							friendDirectMessagesSilent = false;
							ignoreBlockedUsers = true;
						};

						wallpaperFree = {
							enable = true;
							globalDefault = {};
							stylingTips = {};
						};

						webpackTarball = {
							enable = false;
						};

						whitelistedEmojis = {
							enable = false;
						};

						whosWatching = {
							enable = false;
						};

						wigglyText = {
							enable = false;
						};

						writeUpperCase = {
							enable = false;
						};

						youtubeDescription.enable = false;







						# Shared plugins

						accountPanelServerProfile = {
							enable = false;
						};

						alwaysAnimate = {
							enable = false;
						};

						alwaysExpandRoles = {
							enable = false;
						};

						alwaysTrust = {
							enable = false;
						};

						anonymiseFileNames = {
							enable = false;
						};

						appleMusicRichPresence = {
							enable = false;
						};

						autoDndWhilePlaying = {
							enable = false;
						};

						betterFolders = {
							enable = false;
						};

						betterGifAltText.enable = false;
						betterGifPicker.enable = false;

						betterNotesBox = {
							enable = false;
						};

						betterRoleContext = {
							enable = false;
						};

						# -----

						betterSettings = {
							enable = true;
							disableFade = true;
							eagerLoad = true;
							organizeMenu = true;
						};

						customIdle = {
							enable = true;
							idleTimeout = 5.0;
							remainInIdle = true;
						};

						disableCallIdle.enable = true;

						experiments = {
							enable = true;
							toolbarDevMenu = true;
						};

						fakeNitro = {
							enable = true;
							enableEmojiBypass = false;
							enableStickerBypass = false;
							enableStreamQualityBypass = true;
						};

						favoriteEmojiFirst.enable = true;
						friendsSince.enable = true;

						gameActivityToggle = {
							enable = true;
							oldIcon = false;
						};

						implicitRelationships = {
							enable = true;
							sortByAffinity = true;
						};

						ircColors = {
							enable = true;
						};

						mutualGroupDMs.enable = true;

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

					};

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
