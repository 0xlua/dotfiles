{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
  ];

  nix.settings.substituters = ["https://attic.xuyh0120.win/lantian"];
  nix.settings.trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
  nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];
  # boot.kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v4;
  boot.kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.hostName = "callisto"; # Define your hostname.
  networking.networkmanager.enable = true; # Enable networking

  home-manager.users.lua = ./home.nix;

  modules.desktop.enable = true;
  modules.desktop.compositor = "cosmic";
  modules.gaming.enable = true;

  system.stateVersion = "24.11"; # NixOS release for default stateful settings
}
