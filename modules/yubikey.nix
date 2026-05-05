{
  pkgs,
  config,
  ...
}: {
  programs.yubikey-manager = {
    inherit (config.modules.desktop) enable;
    package = pkgs.yubioath-flutter;
  };
}
