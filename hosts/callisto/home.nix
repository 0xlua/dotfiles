{lib, ...}: {
  imports = [../../home];
  nixpkgs.overlays = lib.mkForce null;
  home-modules.desktop.enable = true;
  home-modules.desktop.compositor = "cosmic";
  home-modules.mail.enable = true;
  home-modules.gaming.enable = true;
  home-modules.development = {
    enable = true;
    languages = {
      rust.enable = true;
      python.enable = true;
      javascript.enable = true;
      typesetting.enable = true;
      data.enable = true;
    };
  };
}
