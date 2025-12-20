{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.home-modules.development.languages.typesetting;
in {
  options.home-modules.development.languages.typesetting.enable = lib.mkEnableOption "LaTeX, Typst and Markdown tooling";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tectonic # LaTeX
      texlab # LaTeX lsp

      typst # typst
      tinymist # typst lsp
      typstyle # typst formatter

      markdown-oxide # markdown lsp
      ltex-ls-plus # grammar lsp
    ];

    programs.papis = {
      enable = true;
      libraries = {
        "default" = {
          isDefault = true;
          settings.dir = "~/papers/default";
        };
        "bachelor" = {
          settings.dir = "~/papers/bachelor";
        };
      };
      settings = {
        editor = "hx";
        file-browser = "yazi";
        add-edit = true;
      };
    };

    programs.tex-fmt = {
      enable = true;
      settings = {};
    };
  };
}
