{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  sops.secrets."rustypasteToken".mode = "0440";
  home.packages = with pkgs; [
    # file viewer
    viu # images
    mdcat # md
    doxx # docx
    hygg # pdf
    xleak # xlsx

    # system
    dysk
    dua # disk usage
    sbctl # secure boot
    uutils-coreutils-noprefix # coreutils

    # tools
    rustypaste-cli # pastebin
    ouch # archiving
    managarr # *arr
    podman-tui

    # logs
    tailspin
    hl-log-viewer
  ];
  xdg.configFile."rustypaste/config.toml".source = (pkgs.formats.toml {}).generate "rustypaste-cli-config" {
    server = {
      address = "https://share.lua.one";
      auth_token_file = "${config.sops.secrets."rustypasteToken".path}";
    };
    paste.oneshot = false;
    style.prettify = false;
  };
}
