# <p align="center"> 🌌 Dotfiles </p>

My Nix config. Currently this includes two systems: `callisto` and `europa`. I plan to also include `galileo` and `ganymede` in the future.

## Systems

Most of my systems are named after the galiean moons of jupiter. Except my OPNsense box, which is simply called `jupiter` and my VPS, wich is called `galileo`. Not included here is `io`, my NAS running TrueNAS.

### callisto

This is my computer at home. I use it mainly for gaming and coding. Currently it runs the Cosmic Desktop Preview from System76, which works great so far. I chose the hardware components to be as linux compatible as possible, so no special hardware config is needed.

### europa

This is my laptop; a T480s I bought used. I use it mainly for work. It runs the niri compositor, together with ironbar and centerpiece as the launcher.

### ganymede

This is my server at home and the only system that does not run NixOS (apart from Router/NAS/...). Instead I chose OpenSUSE MicroOS, for two reasons: Before NixOS I ran Tumbleweed, so MicroOS was a natural choice. Also MicroOS is really easy to manage and very close to a zero-conf Server OS for me.

It runs services I only need at home.

For the sake of consistency, I might switch `ganymede` to NixOS, if I get around to it.

### galileo

This is my VPS hosted by Hetzner. It runs services I want to access no matter where I am.

While `galileo` does run NixOS, it is currently not included in this flake. I want to clean up a bit, before I do so.

## About

I like the Nord color scheme and use it basically everywhere. My preferred shell is fish together with the starship prompt. On desktops I use alacritty as the terminal emulator. Helix is my main text editor.

## Acknowledgements

This repo is inspired by sodiboo.
