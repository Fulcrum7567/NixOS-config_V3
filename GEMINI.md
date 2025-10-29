# NixOS Configuration Repository

## Project Overview

This repository contains a comprehensive and modular NixOS configuration managed with Nix Flakes. It's designed to be highly customizable and reproducible, leveraging the power of Nix to define the entire system state, from the kernel to user applications.

The configuration is structured into three main parts:

*   **hosts:** Contains host-specific configurations, allowing for different settings on different machines. The current host is `Hyprdrive`.
*   **system:** Defines system-level settings, including hardware, services, and security policies.
*   **user:** Manages user-specific configurations, such as dotfiles, applications, and themes, using Home Manager.

### Core Technologies

*   **Nix:** The purely functional package manager that makes this reproducible setup possible.
*   **NixOS:** The Linux distribution built on top of Nix.
*   **Nix Flakes:** The new, more structured and reproducible way to manage Nix expressions.
*   **Home Manager:** Manages user-level packages and dotfiles.
*   **sops-nix:** For managing secrets.
*   **stylix:** For system-wide theming and styling.
*   **Hyprland:** A dynamic tiling Wayland compositor.

## Building and Running

The primary script for managing this NixOS configuration is `nixos-diff.sh`. This script simplifies the process of building a new system generation, viewing the changes, and activating it.

### Usage

To build and apply a new configuration, run the following command from the root of the repository:

```bash
./nixos-diff.sh <hostname>
```

Replace `<hostname>` with the target host you want to build for (e.g., `Hyprdrive`).

The script will:

1.  Build the new NixOS configuration for the specified host.
2.  Show a diff of the changes between the new and current system.
3.  Prompt you to switch to the new configuration if there are any changes.

## Development Conventions

*   **Modularity:** The configuration is highly modular. When adding new features or making changes, try to fit them into the existing structure.
*   **Secrets:** Secrets are managed with `sops-nix`. To add or edit secrets, use the `sops` CLI tool.
*   **Theming:** System-wide theming is handled by `stylix`. Themes are defined in the `user/themes` directory.
