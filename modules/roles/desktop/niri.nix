{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.roles.desktop;
in {
  config = lib.mkIf (cfg.compositor == "niri") {
    security.pam.services.gtklock = {};

    environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
          user = config.modules.user.name;
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
