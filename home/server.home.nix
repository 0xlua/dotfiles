{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.hl
  ];
  home-manager.users.lua = {pkgs, ...}: {
    home = {
      packages = with pkgs; [
        tailspin
        # TODO: use ${system}
        hl.packages."x86_64-linux"
        podman-tui
      ];
    };
  };
}
