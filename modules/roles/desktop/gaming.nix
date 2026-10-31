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
    nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];

    nix.settings = {
      substituters = ["https://cache.lantian.pub/lantian"];
      trusted-public-keys = ["lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ="];
    };

    modules = {
      kernel = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v4;
      unfreePackages = [(lib.getName config.programs.steam.package) "steam-unwrapped" "teamspeak6-client" "discord-ptb" "discord-ptb-unwrapped"];
    };

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
