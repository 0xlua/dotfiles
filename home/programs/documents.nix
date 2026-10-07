{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.home-modules.desktop.enable {
    programs.zathura = {
      enable = true;
      options = {
        recolor = true;
        selection-clipboard = "clipboard";
        synctex = true;
        synctex-editor-command = "texlab inverse-search -i %{input} -l %{line}";
      };
    };

    programs.anki.enable = true;
  };
}
