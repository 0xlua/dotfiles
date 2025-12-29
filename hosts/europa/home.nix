{lib, ...}: {
  imports = [../../home];
  nixpkgs.overlays = lib.mkForce null;
  home-modules.desktop.enable = true;
  home-modules.desktop.compositor = "niri";
}
