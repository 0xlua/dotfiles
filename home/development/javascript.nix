{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.home-modules.development.languages.javascript;
in {
  options.home-modules.development.languages.javascript.enable = lib.mkEnableOption "javascript tooling";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      deno #js runtime
      zola # static site renderer
      biome # js lsp
      superhtml # html lsp
    ];
  };
}
