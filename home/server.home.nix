{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.users.lua = {pkgs, ...}: {
    home = {
      packages = with pkgs; [
        tailspin
        # TODO: use ${system}
        # inputs.hl.packages."x86_64-linux".default
        podman-tui
      ];
    };
  };
}
