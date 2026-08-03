{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.secureBoot;
in {
  imports = [inputs.lanzaboote.nixosModules.lanzaboote];

  options.modules.secureBoot.enable = lib.mkEnableOption "Secure Boot";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.sbctl];
    boot = {
      # Lanzaboote currently replaces the systemd-boot module.
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
  };
}
