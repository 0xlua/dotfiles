{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./desktop
    ./programs
    ./editors
    ./development
    ./shell
  ];
  options = {};
  config = {
    sops = {
      defaultSopsFile = ../secrets.yaml;
      # age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      secrets."rustypasteToken".mode = "0440";
    };
    nixpkgs.overlays = lib.mkForce null;
    home = {
      username = "lua";
      homeDirectory = "/home/lua";

      sessionVariables = {
        LANGUAGE = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        MANPAGER = "nvim +Man!";
      };

      keyboard = {
        layout = "us";
        variant = "intl";
        options = "caps:escape";
      };

      language = {
        address = "de_DE.UTF-8";
        base = "en_US.UTF-8";
        collate = "en_US.UTF-8";
        ctype = "en_US.UTF-8";
        measurement = "de_DE.UTF-8";
        messages = "en_US.UTF-8";
        monetary = "de_DE.UTF-8";
        name = "de_DE.UTF-8";
        numeric = "de_DE.UTF-8";
        paper = "de_DE.UTF-8";
        telephone = "de_DE.UTF-8";
        time = "de_DE.UTF-8";
      };

      packages = with pkgs; [
        # terminal viewer
        mdcat # md
        doxx # docx
        # hygg # pdf

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

      stateVersion = "24.05";
    };

    # Let home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.aerc = {
      enable = true;
      extraConfig.general.unsafe-accounts-conf = true;
    };

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "${config.home.homeDirectory}/dotfiles";
    };

    xdg.configFile."rustypaste/config.toml".source = (pkgs.formats.toml {}).generate "rustypaste-cli-config" {
      server = {
        address = "https://share.lua.one";
        auth_token_file = "${config.sops.secrets."rustypasteToken".path}";
      };
      paste.oneshot = false;
      style.prettify = false;
    };
  };
}
