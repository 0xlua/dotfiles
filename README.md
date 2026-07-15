# <p align="center"> 🌌 Dotfiles </p>

My Nix config. Currently this includes three systems: `callisto`, `europa`, `galileo` and `ganymede`.

## About

My preferred shell is fish together with the starship prompt. On desktops I use ghostty as the terminal emulator. Helix is my main text editor.

## Installation

These steps apply only to `europa` at the moment. I have yet to migrate `callisto` and `ganymede` to Full Disk Encryption.

- Make sure Secure Boot is enabled and in Setup Mode
- Download the NixOS Installer, follow the instructions and use the following settings during installation:
  - Language: American English, Europe/Berlin, English (US, intl., with dead keys)
  - username: lua
  - Patition: no swap, btrfs, Encrypt Drive
- Reboot and check if [Secure Boot is supported](https://nix-community.github.io/lanzaboote/introduction.html): `bootctl status`
- You need my age key and put it in `/home/lua/.config/sops/age/key or setup your own [sops-nix](https://github.com/Mic92/sops-nix)
- Build flake: `sudo nixos-rebuild switch --flake github:0xlua/dotfiles#<host>`
- Secure Boot Keys will automatically be created and enrolled after another reboot
- Make sure Secure Boot is [ready to go](https://nix-community.github.io/lanzaboote/getting-started/prepare-your-system.html#verify-your-machine-is-ready): `sudo sbctl verify`

Some stuff still won't work, since they aren't included in the flake:

- GPG keys for email encryption/decrtyption
- SSH keys for git, servers and work
- age keys for sops-nix
- Config stored in podman volumes

## Systems

Most of my systems are named after the galiean moons of jupiter. Except my OPNsense box, which is simply called `jupiter` and my VPS, wich is called `galileo`. Not included here is `io`, my NAS running TrueNAS.

### callisto

This is my computer at home. I use it mainly for gaming and coding. Currently it runs the Cosmic Desktop. For consitency I might switch to Niri in the future. I chose the hardware components to be as linux compatible as possible, so no special hardware config is needed.

### europa

This is my laptop; a T480 I bought used. I use it mainly for work. It runs the niri compositor, together with ironbar and centerpiece as the launcher.

### ganymede

This is my server at home. It runs services I only need at home.

### galileo

This is my VPS hosted by Hetzner. It runs services I want to access no matter where I am.

## Future considerations

- make username, email, etc. configurable -> no hardcoded values in rest of config 
- [Impermanence](https://github.com/nix-community/impermanence): Make sure important paths persist: e.g. Secure Boot keys. Persistent Paths overlap with what should be [backed up](https://github.com/0xlua/dotfiles/issues/124).
- [Measured Boot](https://github.com/nix-community/lanzaboote/blob/master/docs/how-to-guides/enable-measured-boot.md): Includes unlocking the disk using TPM, be aware of [this attack](https://oddlama.org/blog/bypassing-disk-encryption-with-tpm2-unlock/) - use at least a pin
- [Bcachefs](https://wiki.nixos.org/wiki/Bcachefs)
- Automatic / Remote Install: [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) with [disko](https://github.com/nix-community/disko)
- [Switch from sops-nix](https://github.com/0xlua/dotfiles/issues/127) to [fnox](https://github.com/deepwatrcreatur/fnox-flake)
