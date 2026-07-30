{lib, ...}: {
  # Lanzaboote currently replaces the systemd-boot module.
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    initrd.systemd.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
    };
  };
}
