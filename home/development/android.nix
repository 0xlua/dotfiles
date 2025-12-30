{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home-modules.development.android;
in {
  options.home-modules.development.android.enable = lib.mkEnableOption "android dev tools";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      scrcpy # mirror android screen
    ];
  };
}
