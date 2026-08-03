{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.home-modules.desktop.enable {
    home.packages = with pkgs; [
      delfin # jellyfin
      youtube-tui # youtube
    ];

    programs.yt-dlp.enable = true;

    programs.mpv = {
      enable = true;
      package = pkgs.mpv.override {scripts = with pkgs.mpvScripts; [mpris thumbfast modernz];};
    };
  };
}
