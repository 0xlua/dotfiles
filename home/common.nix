{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options.home-modules = {
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "galileo";
      description = "Set the system hostname";
    };
    keyMap = lib.mkOption {
      type = lib.types.str;
      default = "us";
      example = "de";
      description = "keyboard layout";
    };
    user = lib.mkOption {
      type = with lib.types;
        submodule {
          options = {
            name = lib.mkOption {type = str;};
            desc = lib.mkOption {type = str;};
            shell = lib.mkOption {
              type = package;
              default = pkgs.fish;
            };
          };
        };
    };
  };
  config = {
    nixpkgs.overlays = lib.mkForce null;

    sops = {
      defaultSopsFile = ../secrets.yaml;
      # age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };
    home = {
      username = config.home-modules.user.name;

      preferXdgDirectories = true;

      packages = with pkgs; [
        nil # nix lsp
        alejandra # nix formatter
        sops # nix secrets
        uutils-coreutils-noprefix # coreutils
      ];

      sessionVariables = {
        LANGUAGE = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        MANPAGER = "nvim +Man!";
        DO_NOT_TRACK = "true";
      };

      keyboard = {
        layout = config.home-modules.keyMap;
        variant = "intl"; # TODO: only if keyMap == us
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

      stateVersion = "24.05";
    };

    # Let home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "${config.home.homeDirectory}/dotfiles";
    };
  };
}
