{inputs, ...}: {
  imports = [../../home];
  nixpkgs.overlays = [inputs.eilmeldung.overlays.default];
  targets.genericLinux.enable = true;
}
