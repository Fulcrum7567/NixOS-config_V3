{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			programs.noctalia-shell.settings = {
				settings = {
					settingsVersion = 0;
					bar = {
						position = "top";
						monitors = [ ];
						density = "default";
						showOutline = false;
						showCapsule = true;
						capsuleOpacity = 1;
						backgroundOpacity = 0.93;
						useSeparateOpacity = false;
						floating = false;
						marginVertical = 0.25;
						marginHorizontal = 0.25;
						outerCorners = true;
						exclusive = true;
						widgets = {
							left = [
								{
									id = "Launcher";
								}
								{
									id = "Clock";
								}
								{
									id = "SystemMonitor";
								}
								{
									id = "ActiveWindow";
								}
								{
									id = "MediaMini";
								}
							];
							center = [
								{
									id = "Workspace";
								}
							];
							right = [
								{
									id = "ScreenRecorder";
								}
								{
									id = "Tray";
								}
								{
									id = "NotificationHistory";
								}
								{
									id = "Battery";
								}
								{
									id = "Volume";
								}
								{
									id = "Brightness";
								}
								{
									id = "ControlCenter";
								}
							];
						};
					};
					general = {
						avatarImage = "";
						dimmerOpacity = 0.2;
						showScreenCorners = false;
						forceBlackScreenCorners = false;
						scaleRatio = 1;
						radiusRatio = 1;
						iRadiusRatio = 1;
						boxRadiusRatio = 1;
						screenRadiusRatio = 1;
						animationSpeed = 1;
						animationDisabled = false;
						compactLockScreen = false;
						lockOnSuspend = true;
						showSessionButtonsOnLockScreen = true;
						showHibernateOnLockScreen = false;
						enableShadows = true;
						shadowDirection = "bottom_right";
						shadowOffsetX = 2;
						shadowOffsetY = 3;
						language = "";
						allowPanelsOnScreenWithoutBar = true;
						showChangelogOnStartup = true;
					};
					ui = {
						fontDefault = "";
						fontFixed = "";
						fontDefaultScale = 1;
						fontFixedScale = 1;
						tooltipsEnabled = true;
						panelBackgroundOpacity = 0.93;
						panelsAttachedToBar = true;
						settingsPanelMode = "attached";
						wifiDetailsViewMode = "grid";
						bluetoothDetailsViewMode = "grid";
						networkPanelView = "wifi";
						bluetoothHideUnnamedDevices = false;
						boxBorderEnabled = false;
					};
					location = {
						name = "Berlin";
						weatherEnabled = true;
						weatherShowEffects = true;
						useFahrenheit = false;
						use12hourFormat = false;
						showWeekNumberInCalendar = false;
						showCalendarEvents = true;
						showCalendarWeather = true;
						analogClockInCalendar = false;
						firstDayOfWeek = -1;
						hideWeatherTimezone = false;
						hideWeatherCityName = false;
					};

					colorSchemes = {
						useWallpaperColors = false;
						predefinedScheme = "Noctalia (default)";
						darkMode = true;
						schedulingMode = "off";
						manualSunrise = "06:30";
						manualSunset = "18:30";
						matugenSchemeType = "scheme-fruit-salad";
					};
					templates = {
						gtk = false;
						qt = false;
						kcolorscheme = false;
						alacritty = false;
						kitty = false;
						ghostty = false;
						foot = false;
						wezterm = false;
						fuzzel = false;
						discord = false;
						pywalfox = false;
						vicinae = false;
						walker = false;
						code = false;
						spicetify = false;
						telegram = false;
						cava = false;
						yazi = false;
						emacs = false;
						niri = false;
						hyprland = false;
						mango = false;
						zed = false;
						helix = false;
						zenBrowser = false;
						enableUserTemplates = false;
					};
					nightLight = {
						enabled = false;
						forced = false;
						autoSchedule = true;
						nightTemp = "4000";
						dayTemp = "6500";
						manualSunrise = "06:30";
						manualSunset = "18:30";
					};
					hooks = {
						enabled = false;
						wallpaperChange = "";
						darkModeChange = "";
						screenLock = "";
						screenUnlock = "";
						performanceModeEnabled = "";
						performanceModeDisabled = "";
					};
					desktopWidgets = {
						enabled = false;
						gridSnap = false;
						monitorWidgets = [ ];
					};
				};
			};
		};
	};
} 
