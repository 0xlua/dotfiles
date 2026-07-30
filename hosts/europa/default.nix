{
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ./eduroam.nix
  ];
  # Lanzaboote currently replaces the systemd-boot module.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.initrd.systemd.enable = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys = {
      enable = true;
      autoReboot = true;
    };
  };
  nixpkgs.overlays = [
    (final: prev: {
      wayprompt = let
        version = "0.1.2-mzte.2";
        src = final.fetchFromGitea {
          domain = "git.mzte.de";
          owner = "LordMZTE";
          repo = "wayprompt";
          tag = "v${version}";
          hash = "sha256-uVkeLJgvdc6c7xmNUdWlUS1f3fx8cCIV/raw2prP4O4=";
        };
        deps = final.zig_0_16.fetchDeps {
          inherit version src;
          pname = "wayprompt";
          hash = "sha256-j1SrpUFgrtcv2pf43ZxRo3poYtMDQnWS3vmKkU5trE0=";
        };
      in
        prev.wayprompt.overrideAttrs {
          inherit version src;

          nativeBuildInputs = with final; [
            zig_0_16
            pkg-config
            wayland
            wayland-scanner
            scdoc
          ];

          zigBuildFlags = [];

          preBuild = ''
            ln -sf "${deps}" "$ZIG_GLOBAL_CACHE_DIR/p"
          '';
        };
    })
  ];

  networking = let
    dhcpInterfaces = ["enp0s31f6"];
  in {
    hostName = "europa"; # Define your hostname.
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
      enable = true; # Enable networking
      wifi.backend = "iwd";
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        # FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  services.blueman.enable = true;

  console.keyMap = "uk"; # Configure console keymap

  home-manager.users.lua = ./home.nix;

  modules.desktop.enable = true;
  modules.desktop.compositor = "niri";

  system.stateVersion = "26.05"; # NixOS release for default stateful settings
}
