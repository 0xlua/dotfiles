{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
  ];

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
