{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.modules;
in {
  config = lib.mkIf (cfg.desktop.compositor == "niri") {
    nixpkgs.overlays = [inputs.niri.overlays.niri];
    nix.settings = {
      substituters = ["https://niri-epireyn.cachix.org"];
      trusted-public-keys = ["niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="];
    };

    security.pam.services.gtklock = {};

    environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];

    services.upower.enable = true;

    services.hardware.bolt.enable = true;

    services.thermald.enable = true;

    services.auto-cpufreq = {
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

    powerManagement.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
          user = "lua";
        };
      };
    };

    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
