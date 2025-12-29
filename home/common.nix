{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  sops = {
    defaultSopsFile = ../secrets.yaml;
    # age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
  home = {
    username = "lua";
    homeDirectory = "/home/lua";

    packages = with pkgs; [
      nil # nix lsp
      alejandra # nix formatter
      sops # nix secrets
    ];

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
}
