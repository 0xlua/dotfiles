{
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
  ];
  # Lanzaboote currently replaces the systemd-boot module.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.initrd.systemd.enable = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  networking.hostName = "europa"; # Define your hostname.
  networking.networkmanager.enable = true; # Enable networking

  console.keyMap = "uk"; # Configure console keymap

  home-manager.users.lua = ./home.nix;

  modules.desktop.enable = true;
  modules.desktop.compositor = "niri";

  system.stateVersion = "24.05"; # NixOS release for default stateful settings
}
