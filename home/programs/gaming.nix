{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.home-modules;
in {
  options.home-modules.gaming.enable = lib.mkEnableOption "gaming";
  config = lib.mkIf cfg.gaming.enable {
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
