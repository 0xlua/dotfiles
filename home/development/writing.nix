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

    xdg.configFile."moxide/settings.toml".source = (pkgs.formats.toml {}).generate "markdown-oxide" {
      include_md_extension_md_link = true;
      include_md_extension_wikilink = true;
    };

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
