{
  lib,
  config,
  ...
}: let
  cfg = config.modules.roles.laptop;
in {
  imports = [./eduroam.nix];
  options.modules.roles.laptop = {
    enable = lib.mkEnableOption "the laptop role";
  };

  config = lib.mkIf cfg.enable {
    powerManagement.enable = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General.Experimental = true;
        Policy.AutoEnable = true;
      };
    };

    services = {
      # blueman.enable = !config.modules.roles.desktop.preferLessGuis;
      blueman.enable = true;
      upower.enable = true;
      hardware.bolt.enable = true;
      thermald.enable = true;
      auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            turbo = "never";
          };
          charger = {
            governor = "performance";
            turbo = "auto";
          };
        };
      };
    };

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
  };
}
