{lib, ...}: {
  imports = [./hetzner.nix ./fail2ban.nix];
  options.home-modules.roles.vps.enable = lib.mkEnableOption "the VPS role";
}
