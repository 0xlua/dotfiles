{lib, ...}: {
  imports = [../../home];
  nixpkgs.overlays = lib.mkForce null;
  home-modules.development = {
    enable = true;
    languages = {
      data.enable = true;
    };
  };
}
