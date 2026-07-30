{...}: {
  networking = let
    dhcpInterfaces = ["enp0s31f6"];
  in {
    dhcpcd = {
      enable = true;
      allowInterfaces = dhcpInterfaces;
    };
    wireless.iwd = {
      enable = true;
      settings.General = {
        EnableNetworkConfiguration = "True";
        AddressRandomization = "once";
      };
    };
    networkmanager = {
      unmanaged = dhcpInterfaces;
      wifi.backend = "iwd";
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General.Experimental = true;
      Policy.AutoEnable = true;
    };
  };
  services.blueman.enable = true;
}
