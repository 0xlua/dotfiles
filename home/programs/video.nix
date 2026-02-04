{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.home-modules.desktop.enable {
    home.packages = with pkgs; [delfin youtube-tui];

    programs.yt-dlp.enable = true;

    programs.mpv.enable = true;
  };
}
