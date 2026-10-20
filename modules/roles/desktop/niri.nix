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
      useTextGreeter = true;
      settings = {
        default_session = {
          command = "${lib.getExe pkgs.tuigreet} --time --remember --cmd niri-session";
          user = config.modules.user.name;
        };
      };
    };
  };
}
