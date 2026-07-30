{lib, ...}: {
  # Use the GRUB 2 boot loader.
  boot.loader = {
    efi.canTouchEfiVariables = lib.mkForce false;
    systemd-boot.enable = lib.mkForce false;
    grub = {
      enable = true;
      device = "/dev/sda"; # or "nodev" for efi only
      configurationLimit = 10;
    };
  };

  networking = {
    useNetworkd = true;
    networkmanager.enable = lib.mkForce false;
  };

  systemd.network = {
    enable = true;
    networks."10-wan" = {
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
  };
}
