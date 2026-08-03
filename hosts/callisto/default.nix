{
  pkgs,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

  modules = {
    hostname = "callisto";
    kernel = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4;
    user = {
      name = "lua";
      desc = "Lua";
    };
    roles = {
      desktop = {
        enable = true;
        compositor = "cosmic";
        gaming.enable = true;
      };
    };
  };

  system.stateVersion = "24.11"; # NixOS release for default stateful settings
}
