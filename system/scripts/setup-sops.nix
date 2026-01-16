{ config, pkgs-default, ... }:

let
  setupSopsScript = pkgs-default.writeShellScriptBin "setup-sops" ''
    # Default location for sops-nix keys
    KEY_DIR="/var/lib/sops-nix/"
    KEY_FILE="$KEY_DIR/keys.txt"

    # Check if running as root
    if [ "$EUID" -ne 0 ]; then
      echo "❌ Error: Please run as root (use sudo)"
      exit 1
    fi

    echo "🔐 Setting up Sops-Nix Master Key"
    echo "Target: $KEY_FILE"
    echo "-----------------------------------"

    # Check if key already exists to prevent accidental overwrite
    if [ -f "$KEY_FILE" ]; then
        read -p "⚠️  A key file already exists. Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborting."
            exit 1
        fi
    fi

    # Prompt for the key securely (silent input)
    echo "Please paste your Age Private Key (starts with AGE-SECRET-KEY-1...):"
    read -s AGE_KEY

    # Basic Validation
    if [[ "$AGE_KEY" != AGE-SECRET-KEY-1* ]]; then
        echo ""
        echo "❌ Error: That doesn't look like a valid Age secret key."
        echo "It should start with 'AGE-SECRET-KEY-1'."
        exit 1
    fi

    # Create directory if it doesn't exist
    mkdir -p "$KEY_DIR"

    # Write the file
    echo "$AGE_KEY" > "$KEY_FILE"

    # Set permissions: Read/Write for owner ONLY.
    # This is critical. Sops/SSH often refuse to read keys with open permissions.
    chmod 600 "$KEY_FILE"
    chown ${config.user.settings.username}:users "$KEY_FILE"

    echo ""
    echo "✅ Success!"
    echo "   Key saved to: $KEY_FILE"
    echo "   Permissions set to 600 (owner only)."
    echo ""
    echo "You can now run 'nixos-rebuild switch' to decrypt your secrets."
  '';
in
{
  environment.systemPackages = [ setupSopsScript ];
}
