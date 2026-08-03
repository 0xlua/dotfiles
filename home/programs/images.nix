{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.home-modules.desktop.enable {
    home.packages = with pkgs; [oculante];
  };
}
