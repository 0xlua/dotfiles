{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.home-modules.desktop.gaming;
in {
  options.home-modules.desktop.gaming.enable = lib.mkEnableOption "gaming";
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.home-modules.desktop.enable;
        message = "Set home-modules.desktop.enable = true, if you want to enable gaming";
      }
    ];

    home.packages = with pkgs; [
      steamguard-cli
      mumble
      teamspeak6-client
      chess-tui
      # mangohud
    ];
    home.file.counterstrike-autoexec = {
      target = ".steam/steam/steamapps/common/Counter-Strike\ Global\ Offensive/game/csgo/cfg/autoexec.cfg";
      source = ../../files/autoexec.cfg;
      force = true;
    };
    programs.discord = {
      enable = true;
      package = pkgs.discord-ptb;
    };
  };
}
