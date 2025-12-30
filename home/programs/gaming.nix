{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.home-modules.gaming;
in {
  options.home-modules.gaming.enable = lib.mkEnableOption "gaming";
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.home-modules.desktop.enable;
        message = "Set home-modules.desktop.enable = true, if you want to enable gaming";
      }
    ];

    home.packages = with pkgs; [
      lact
      mumble
      teamspeak6-client
      chess-tui
      # bottles
      # mangohud
    ];
    programs.obs-studio = {
      enable = true;
    };
    programs.discord = {
      enable = true;
      package = pkgs.discord-ptb;
    };
  };
}
