{lib, ...}: {
  imports = [./hetzner.nix ./fail2ban.nix];
  options.modules.roles.vps.enable = lib.mkEnableOption "the VPS role";
}
