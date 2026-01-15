{ config, lib, settings, currentHost, ... }:
{
	options.packages.${settings.optionName} = {

		availableConfigs = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available configs for the ${settings.displayName} package.";
		};

		activeConfig = lib.mkOption {
			type = lib.types.enum (config.packages.${settings.optionName}.availableConfigs or []);
			default = "default"; # A default config should always exist, delete if not
			description = "Set the active configuration for the ${settings.displayName} package.";
		};

		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable the ${settings.displayName} package.";
		};

		commonIgnores = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        # --- General / OS Metadata ---
        ".DS_Store"             # macOS Metadata
        ".AppleDouble"          # macOS Resource forks
        ".LSOverride"           # macOS
        "Thumbs.db"             # Windows Thumbnails
        "ehthumbs.db"           # Windows Thumbnails
        "desktop.ini"           # Windows Folder Config
        "*~"                    # Linux/Editor Backup files
        "*.tmp"                 # Temporary files
        ".Trash-*"              # Linux Trash folders

        # --- Version Control ---
        ".git"                  # Git repository data (heavy!)
        ".svn"
        ".hg"

        # --- Python ---
        "__pycache__"           # Compiled Python bytecode
        "*.pyc"
        "*.pyo"
        "*.pyd"
        ".venv"                 # Virtual Environments (Local only!)
        "venv"
        "env"
        ".env"                  # Environment secrets (Careful syncing these!)
        ".pytest_cache"         # Test caches
        ".mypy_cache"           # Type checking caches
        ".ipynb_checkpoints"    # Jupyter Notebook autosaves

        # --- JavaScript / Node / Web ---
        "node_modules"          # The #1 cause of Syncthing slowdowns
        "bower_components"
        "jspm_packages"
        "dist"                  # Build output
        "build"                 # Build output
        ".next"                 # Next.js build
        ".nuxt"                 # Nuxt.js build
        "coverage"              # Test coverage reports
        ".npm"                  # NPM logs/cache
        ".yarn"                 # Yarn cache

        # --- C / C++ / Rust / Go ---
        "*.o"                   # Object files
        "*.so"                  # Shared libraries
        "*.dll"
        "*.exe"                 # Executables
        "*.dylib"
        "target"                # Rust build folder (Very heavy)
        "bin"                   # Go/General bin folder
        "obj"                   # C# / General obj folder

        # --- IDEs / Editors ---
        ".idea"                 # JetBrains (IntelliJ, PyCharm, etc.)
        ".vscode"               # VS Code (User-specific settings)
        "*.swp"                 # Vim swap files
        "*.swo"
        "*.sublime-workspace"   # Sublime Text
      ];
      description = "List of common ignore patterns for Syncthing folders.";
    };
	};
}