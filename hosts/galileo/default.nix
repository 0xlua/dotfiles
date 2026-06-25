{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
  ];
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.loader.grub.configurationLimit = 10;

  home-manager.users.lua = ./home.nix;

  networking.hostName = "galileo"; # Define your hostname.

  networking.useNetworkd = true;

  server = {
    enable = true;
    atuin.enable = true;
    # podman-backup.enable = true;
    bore-server.enable = true;
    caddy.enable = true; # TODO: make Caddyfile config option
    bookstack.enable = true;
    kitchenowl.enable = true;
    linkding.enable = true;
    littlelink.enable = true;
    miniflux.enable = true;
    pocket-id.enable = true;
    redlib.enable = true;
    rustypaste.enable = true;
    stalwart.enable = true;
    upvoterss.enable = true;
    vaultwarden.enable = true;
  };

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

  networking.nftables.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [25 80 443 465 993 7835]; # smtp, http, https, smtps, imaps, bore
  };

  services.fail2ban.enable = true;

  system.stateVersion = "24.05"; # Don't change
}
