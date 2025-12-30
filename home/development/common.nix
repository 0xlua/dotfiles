{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.home-modules.development;
in {
  options.home-modules.development.enable = lib.mkEnableOption "dev tooling";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
        mago # php lsp
        stylua # lua formatter
        hurl # HTTP Requests from files
        just # command runner
        grex # regex generator
      ]
      ++ lib.lists.optional config.home-modules.desktop.enable yaak;
  };
}
