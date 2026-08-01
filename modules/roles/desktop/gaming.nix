{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.modules.roles.desktop;
in {
  options.modules.roles.desktop.gaming.enable = lib.mkEnableOption "gaming";

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

    hardware.amdgpu.overdrive.enable = true;

    users.users.${config.modules.user.name}.extraGroups = ["gamemode"];

    programs = {
      steam = {
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

      gamescope = {
        enable = true;
        capSysNice = true;
      };

      gamemode = {
        enable = true;
        settings.general.inhibit_screensaver = 0;
      };

      corectrl.enable = true;
    };

    services = {
      lact.enable = true;
      sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true;
        openFirewall = true;
      };
    };
  };
}
