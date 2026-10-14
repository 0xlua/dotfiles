{
  pkgs,
  lib,
  ...
}: let
  unfree = with pkgs; [
    # ventoy-full
    veracrypt
  ];
in {
  modules.unfreePackages = lib.map lib.getName unfree;
  environment.systemPackages = unfree;
}
