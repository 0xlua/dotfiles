{...}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "callisto"; # Define your hostname.

  networking.networkmanager.enable = true; # Enable networking

  system.stateVersion = "24.11"; # NixOS release for default stateful settings
}
