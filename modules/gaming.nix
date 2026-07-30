{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.modules;
in {
  options.modules.gaming.enable = lib.mkEnableOption "gaming";

  config = lib.mkIf cfg.gaming.enable {
    nixpkgs = {
      config.allowUnfree = true;
      overlays = [inputs.nix-cachyos-kernel.overlays.pinned];
    };

    nix.settings = {
      substituters = ["https://attic.xuyh0120.win/lantian"];
      trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
    };

    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v4;

    programs.corectrl.enable = true;

    # services.lact.enable = true;

    hardware.amdgpu.overdrive.enable = true;

    programs.gamemode = {
      enable = true;
      settings.general.inhibit_screensaver = 0;
    };

    users.users.lua.extraGroups = ["gamemode"];

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    programs.steam = {
      enable = true;
      # extest.enable = true; # steam input wayland compat
      gamescopeSession = {
        enable = true;
        args = [
          "--adaptive-sync"
          "--hdr-enabled"
          # "--mangoapp"
          "--rt"
        ];
      };
      extraCompatPackages = with pkgs; [proton-ge-bin];
    };

    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
