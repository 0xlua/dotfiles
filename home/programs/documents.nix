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
        synctex = true;
        synctex-editor-command = "texlab inverse-search -i %{input} -l %{line}";
      };
    };

    programs.anki.enable = true;

    xdg.mimeApps.associations.removed = {"application/pdf" = ["com.github.flxzt.rnote.desktop"];};

    xdg.mimeApps.defaultApplications."application/pdf" = ["org.pwmt.zathura.desktop"];
  };
}
