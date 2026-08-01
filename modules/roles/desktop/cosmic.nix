{
  config,
  lib,
  ...
}: let
  cfg = config.modules.roles.desktop;
in {
  config = lib.mkIf (cfg.compositor == "cosmic") {
    services = {
      desktopManager.cosmic = {
        enable = true;
        xwayland.enable = true;
      };
      displayManager.cosmic-greeter.enable = true;
      system76-scheduler.enable = true;
      gnome.gnome-keyring.enable = false;
    };

    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

    programs.dconf.enable = true;
  };
}
