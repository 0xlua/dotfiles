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
      postgres-language-server # postgres

      # formats
      jaq # json, yaml, toml, xml, ...
      tabiew # csv, sql, excel
      rainfrog # database client
      squix # sql stash

      # Misc
      stu # s3 client
    ];
  };
}
