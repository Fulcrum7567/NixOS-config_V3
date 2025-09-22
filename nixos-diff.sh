#!/usr/bin/env bash

# A script to build a new NixOS configuration, show a clean diff,
# and optionally switch to it if changes exist.

# Exit immediately if a command fails
set -e

# --- 0. Prerequisite Check ---
if ! command -v nix-diff &> /dev/null; then
    echo "❌ Error: 'nix-diff' command not found."
    echo "   Please add 'nix-diff' to 'environment.systemPackages' in your NixOS configuration and rebuild."
    exit 1
fi

# --- 1. Argument Check ---
if [ -z "$1" ]; then
  echo "❌ Error: No hostname provided."
  echo "   Usage: ./nixos-diff.sh <your-hostname>"
  exit 1
fi

HOSTNAME=$1
FLAKE_TARGET=".#nixosConfigurations.$HOSTNAME.config.system.build.toplevel"

echo "⚙️  Building configuration for '$HOSTNAME'..."

# --- 2. Build the System ---
NEW_SYSTEM_PATH=$(nix build "$FLAKE_TARGET" --no-link --print-out-paths)

if [ -z "$NEW_SYSTEM_PATH" ]; then
    echo "❌ Build failed. Please check the logs above."
    exit 1
fi

echo "✅ Build complete. New system is at: $NEW_SYSTEM_PATH"

# --- 3. Run the Diff and Filter ---
echo "🔎 Comparing new build with currently running system..."

# Run nix-diff and use grep to filter out the top-level system path changes.
# The `|| true` ensures the script doesn't exit if grep finds no matches.
DIFF_OUTPUT=$(nix-diff /run/current-system "$NEW_SYSTEM_PATH" | grep -vE -- '(/run/current-system|nixos-system-.*):\{out\}' || true)

# --- 4. Check for Changes and Prompt ---
# Trim whitespace to ensure an accurate check.
if [ -z "$(echo "$DIFF_OUTPUT" | tr -d '[:space:]')" ]; then
  echo "✅ No significant changes detected. Your system is already up to date."
  exit 0
else
  # If changes exist, print them and prompt the user.
  echo "------------------------------------------------------"
  echo "$DIFF_OUTPUT"
  echo "------------------------------------------------------"
  echo

  read -p "Do you want to switch to this new configuration? (y/N) " -n 1 -r
  echo # Move to a new line after the prompt

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Activating the new system configuration..."
    sudo "$NEW_SYSTEM_PATH/bin/switch-to-configuration" switch
    echo "✅ Done! Your system is now up to date."
  else
    echo "🛑 Switch aborted. The new configuration was not activated."
  fi
fi