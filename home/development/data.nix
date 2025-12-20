{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.home-modules.development.languages.data;
in {
  options.home-modules.development.languages.data.enable = lib.mkEnableOption "tools for data manipulation";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # LSP
      taplo # toml
      postgres-language-server

      # json
      jnv # interactive jq filter
      jaq # faster jq clone

      # CSV (choose one)
      qsv # manipulate csv
      xan # process csv: view, plots, etc
      tabiew # view csv

      # Misc
      rainfrog # database client
    ];
  };
}
