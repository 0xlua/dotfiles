{pkgs, ...}: {
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.loader.grub.configurationLimit = 10;

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
    settings = {
      PasswordAuthentication = false;
      AllowUsers = ["lua"];
      UseDns = true;
      PermitRootLogin = "no";
    };
  };

  # Rely on Cloud Firewall
  # TODO: don't rely on cloud firewall
  networking.firewall.enable = false;

  # TODO: enable fail2ban
  services.fail2ban.enable = false;

  system.stateVersion = "24.05"; # Don't change
}
