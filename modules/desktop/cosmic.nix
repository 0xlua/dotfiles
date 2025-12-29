{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.modules;
in {
  config = lib.mkIf (cfg.desktop.compositor == "cosmic") {
    nixpkgs.overlays = [inputs.eilmeldung.overlays.default];
    services.desktopManager.cosmic.enable = true;
    services.gnome.gnome-keyring.enable = false;
    services.desktopManager.cosmic.xwayland.enable = true;
    services.displayManager.cosmic-greeter.enable = true;

    programs.dconf.enable = true;
  };
}
