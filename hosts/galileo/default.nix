{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
  ];
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.loader.grub.configurationLimit = 10;

  home-manager.users.lua = ./home.nix;

  server = {
    atuin.enable = true;
    # podman-backup.enable = true;
    bore-server.enable = true;
    caddy.enable = true; # TODO: make Caddyfile config option
    kitchenowl.enable = true;
    linkding.enable = true;
    littlelink.enable = true;
    miniflux.enable = true;
    pocketid.enable = true;
    redlib.enable = true;
    rustypaste.enable = true;
    stalwart.enable = true;
    upvoterss.enable = true;
    vaultwarden.enable = true;
  };

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
    dates = "Fri 04:00 Europe/Berlin";
  };

  systemd = {
    services.clear-log = {
      description = "Clear >1 month-old logs every week";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=30d";
      };
    };
    timers.clear-log = {
      wantedBy = ["timers.target"];
      partOf = ["clear-log.service"];
      timerConfig.OnCalendar = "weekly Europe/Berlin";
    };
  };

  networking.hostName = "galileo"; # Define your hostname.

  networking.useNetworkd = true;

  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0";
    networkConfig.DHCP = "ipv4";
    address = [
      "157.90.165.87/32"
      "2a01:4f8:1c1c:1dc9::1/64"
    ];
    routes = [
      {
        Gateway = "172.31.1.1";
        GatewayOnLink = true;
      }
      {Gateway = "fe80::1";}
    ];
  };

  users.users.root.hashedPassword = "*";

  programs.rust-motd = {
    enable = true;
    settings = {
      service_status = {
        littlelink = "podman-littlelink";
        rustypaste = "podman-rustypaste";
        stalwart = "podman-stalwart";
        bore = "podman-bore";
        caddy = "podman-caddy";
        redlib = "podman-redlib";
        linkding = "podman-linkding";
        vaultwarden = "podman-vaultwarden";
        pocket-id = "podman-pocket-id";
        upvoterss = "podman-upvoterss";
        kitchenowl = "podman-stalwart";
        miniflux = "podman-miniflux";
        atuin = "podman-atuin";
      };
      uptime.prefix = "Up";
      load_avg.format = "Load (1, 5, 15 min.): {one:.02}, {five:.02}, {fifteen:.02}";
      memory.swap_pos = "none";
      fail_2_ban.jails = ["sshd"];
      last_login = {
        lua = 3;
        root = 1;
      };
      filesystems = {
        root = "/";
      };
    };
  };

  programs.fish.enable = true;
  users.users.lua = {
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFXnCtIbRMHYs6zmB/LNqARTJbIK+SWMpghHIDBJ7hiS"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJlfUoi3tLKbWSaqrGbqy76GbeDua/LZvOVkSGfX1J2p"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      AllowUsers = ["lua"];
      UseDns = true;
      PermitRootLogin = "no";
    };
  };

  networking.nftables.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [25 80 443 465 993 7835]; # smtp, http, https, smtps, imaps, bore
  };

  services.fail2ban.enable = true;

  system.stateVersion = "24.05"; # Don't change
}
