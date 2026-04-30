{
  config,
  lib,
  ...
}: let
  cfg = config.modules;
in {
  config = lib.mkIf (cfg.desktop.compositor == "cosmic") {
    services.desktopManager.cosmic.enable = true;
    services.gnome.gnome-keyring.enable = false;
    services.desktopManager.cosmic.xwayland.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
    services.system76-scheduler.enable = true;

    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

    programs.dconf.enable = true;
  };
}
