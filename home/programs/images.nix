{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.home-modules.desktop.enable {
    home.packages = with pkgs; [oculante];
    xdg.mimeApps.defaultApplications = let
      imageViewer = ["oculante.desktop"];
    in {
      # Images
      "image/jpeg" = imageViewer;
      "image/png" = imageViewer;
      "image/gif" = imageViewer;
      "image/webp" = imageViewer;
      "image/tiff" = imageViewer;
    };
  };
}
