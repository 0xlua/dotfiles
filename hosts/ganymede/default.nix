{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  home-manager.users.lua = ./home.nix;

  networking.hostName = "ganymede"; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;

  programs.fish.enable = true;
  users.users.lua = {
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFXnCtIbRMHYs6zmB/LNqARTJbIK+SWMpghHIDBJ7hiS"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJlfUoi3tLKbWSaqrGbqy76GbeDua/LZvOVkSGfX1J2p"
    ];
  };

  users.users.root.hashedPassword = "*";

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      # PasswordAuthentication = false;
      AllowUsers = ["lua"];
      UseDns = true;
      PermitRootLogin = "no";
    };
  };

  system.stateVersion = "25.11"; # Don't change
}
