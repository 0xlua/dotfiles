{
  pkgs,
  config,
  ...
}: {
  programs.yubikey-manager = {
    enable = config.modules.desktop.enable;
    package = pkgs.yubioath-flutter;
  };
}
