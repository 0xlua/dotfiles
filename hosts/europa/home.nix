{lib, ...}: {
  imports = [../../home];
  nixpkgs.overlays = lib.mkForce null;
  home-modules.desktop.enable = true;
  home-modules.desktop.compositor = "niri";
  home-modules.development = {
    enable = true;
    languages = {
      android.enable = true;
      rust.enable = true;
      python.enable = true;
      javascript.enable = true;
      typesetting.enable = true;
      data.enable = true;
    };
  };
}
