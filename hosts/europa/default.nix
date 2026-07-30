{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ./eduroam.nix
    ./secureboot.nix
    ./laptop.nix
  ];

  networking.hostName = "europa";

  console.keyMap = "uk"; # Configure console keymap

  home-manager.users.lua = ./home.nix;

  modules.desktop = {
    enable = true;
    compositor = "niri";
  };

  system.stateVersion = "26.05"; # NixOS release for default stateful settings
}
