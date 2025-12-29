{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules;
in {
  config = lib.mkIf (cfg.desktop.compositor == "niri") {
    security.pam.services.gtklock = {};

    environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];

    services.upower.enable = true;

    services.hardware.bolt.enable = true;

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
