{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home-modules.development.languages.android;
in {
  options.home-modules.development.languages.android.enable = lib.mkEnableOption "android dev tools";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      scrcpy # mirror android screen
    ];
  };
}
