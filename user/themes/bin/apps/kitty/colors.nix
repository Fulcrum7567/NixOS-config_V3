{ config, lib, ... }:
{
	config.home-manager.users.${config.user.settings.username} = {
		programs.kitty = {
			settings = {
				# --- Core Colors ---
				# Map the base16 semantic roles to Kitty's color options.
				# The YAML files provide hex strings without the '#', so we add it here.
				foreground = "#${config.colorScheme.palette.base05}";
				background = "#${config.colorScheme.palette.base00}";

				# --- Cursor ---
				cursor = "#${config.colorScheme.palette.base05}"; # Cursor block color
				cursor_text_color = "#${config.colorScheme.palette.base00}"; # Text under the cursor

				# --- Selection ---
				selection_background = "#${config.colorScheme.palette.base02}";
				selection_foreground = "#${config.colorScheme.palette.base07}";

				# --- The 16 ANSI colors ---
				# These are used by terminal programs like ls, vim, htop, etc.

				# Normal colors
				color0  = "#${config.colorScheme.palette.base01}"; # Black
				color1  = "#${config.colorScheme.palette.base08}"; # Red
				color2  = "#${config.colorScheme.palette.base0B}"; # Green
				color3  = "#${config.colorScheme.palette.base0A}"; # Yellow
				color4  = "#${config.colorScheme.palette.base0D}"; # Blue
				color5  = "#${config.colorScheme.palette.base0E}"; # Magenta
				color6  = "#${config.colorScheme.palette.base0C}"; # Cyan
				color7  = "#${config.colorScheme.palette.base06}"; # White

				# Bright colors
				color8  = "#${config.colorScheme.palette.base03}"; # Bright Black (Grey)
				color9  = "#${config.colorScheme.palette.base09}"; # Bright Red (Orange)
				color10 = "#${config.colorScheme.palette.base0B}"; # Bright Green
				color11 = "#${config.colorScheme.palette.base0A}"; # Bright Yellow
				color12 = "#${config.colorScheme.palette.base0D}"; # Bright Blue
				color13 = "#${config.colorScheme.palette.base0E}"; # Bright Magenta
				color14 = "#${config.colorScheme.palette.base0C}"; # Bright Cyan
				color15 = "#${config.colorScheme.palette.base07}"; # Bright White

				# --- Window Decoration and Title Bar ---
				# This makes the title bar match the background color of the active tab
				active_tab_background = "#${config.colorScheme.palette.base00}";
				active_tab_foreground = "#${config.colorScheme.palette.base05}";

				# Color for inactive tabs/windows
				inactive_tab_background = "#${config.colorScheme.palette.base01}";
				inactive_tab_foreground = "#${config.colorScheme.palette.base03}";

				# Window borders
				active_border_color = "#${config.colorScheme.palette.base0D}";   # Use an accent color
				inactive_border_color = "#${config.colorScheme.palette.base01}"; # Use a subtle background color

				# For Wayland, you can sometimes force the title bar color directly
				wayland_titlebar_color = "#${config.colorScheme.palette.base00}";
			};
		};
	};
} 
