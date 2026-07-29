{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
  ];

  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
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

  nix.settings.substituters = ["https://attic.xuyh0120.win/lantian"];
  nix.settings.trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
  # boot.kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v4;
  boot.kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.hostName = "callisto"; # Define your hostname.
  networking.networkmanager.enable = true; # Enable networking

  home-manager.users.lua = ./home.nix;

  modules.desktop.enable = true;
  modules.desktop.compositor = "cosmic";
  modules.gaming.enable = true;

  system.stateVersion = "24.11"; # NixOS release for default stateful settings
}
