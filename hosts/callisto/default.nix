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

  networking.hostName = "callisto"; # Define your hostname.

  home-manager.users.lua = ./home.nix;

  modules = {
    desktop = {
      enable = true;
      compositor = "cosmic";
    };
    gaming.enable = true;
  };

  boot.kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4;

  system.stateVersion = "24.11"; # NixOS release for default stateful settings
}
