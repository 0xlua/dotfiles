{...}: {
  imports = [./hardware-configuration.nix];

  modules = {
    hostname = "europa";
    keyMap = "uk";
    secureBoot.enable = true;
    user = {
      name = "lua";
      desc = "Lua";
    };
    roles = {
      laptop.enable = true;
      desktop = {
        enable = true;
        compositor = "niri";
      };
    };
  };

  system.stateVersion = "26.05"; # NixOS release for default stateful settings
}
