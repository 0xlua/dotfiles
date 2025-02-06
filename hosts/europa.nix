{...}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "europa"; # Define your hostname.

  networking.networkmanager.enable = true; # Enable networking

  console.keyMap = "uk"; # Configure console keymap

  system.stateVersion = "24.05"; # NixOS release for default stateful settings
}
