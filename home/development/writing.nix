{pkgs, ...}: {
  home.packages = with pkgs; [
    # Languages
    tectonic
    typst

    # LSP
    texlab
    tinymist
    markdown-oxide
    ltex-ls-plus

    # Formatter
    typstyle
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
}
