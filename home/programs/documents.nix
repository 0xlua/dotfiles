{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.home-modules.desktop.enable {
    home.packages = with pkgs; [rnote];

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
