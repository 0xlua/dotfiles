{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  home-manager.users.lua = ./home.nix;

  networking.hostName = "ganymede"; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;

  server = {
    enable = true;
    jellyfin.enable = true;
    jellyfin.publiclyAccessible = true;
    mafl.enable = true;
    arr.enable = true;
    arr.deluge.enable = true;
    arr.flaresolverr.enable = true;
    arr.prowlarr.enable = true;
    arr.radarr.enable = true;
    arr.sonarr.enable = true;
    arr.bazarr.enable = true;
  };

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

  sops = {
    secrets = {
      "nas/username_server" = {};
      "nas/domain" = {};
      "nas/password" = {};
    };
    templates = {
      "smb-secret-server" = {
        owner = "lua";
        content = ''
          username=${config.sops.placeholder."nas/username_server"}
          domain=${config.sops.placeholder."nas/domain"}
          password=${config.sops.placeholder."nas/password"}
        '';
      };
    };
  };

  environment.systemPackages = [pkgs.cifs-utils];

  fileSystems."/home/lua/media" = {
    device = "//io.internal/media";
    fsType = "cifs";
    options = let
      automount_opts = "nobrl,x-systemd.automount,x-systemd.requires=network-online.target";
    in ["${automount_opts},credentials=${config.sops.templates."smb-secret-server".path},uid=1000,gid=100"];
  };

  fileSystems."/home/lua/scanner" = {
    device = "//io.internal/scanner";
    fsType = "cifs";
    options = let
      automount_opts = "nobrl,x-systemd.automount,x-systemd.requires=network-online.target";
    in ["${automount_opts},credentials=${config.sops.templates."smb-secret-server".path},uid=1000,gid=100"];
  };

  system.stateVersion = "25.11"; # Don't change
}
