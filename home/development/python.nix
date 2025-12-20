{
  lib,
  config,
  ...
}: let
  cfg = config.home-modules.development.languages.python;
in {
  options.home-modules.development.languages.python.enable = lib.mkEnableOption "python tooling";

  config = lib.mkIf cfg.enable {
    programs.ruff = {
      enable = true;
      settings = {};
    };

    programs.uv = {
      enable = true;
    };

    programs.ty = {
      enable = true;
    };
  };
}
