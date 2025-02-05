{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];

  nix.settings.experimental-features = "nix-command flakes";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # nix.gc = {
  #   automatic = true;
  #   dates = "daily";
  #   options = "--delete-older-than 7d";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure console keymap
  console.keyMap = lib.mkDefault "us";

  nix.extraOptions = ''
    trusted-users = root lua
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';

  users.mutableUsers = false;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/home/lua/.ssh/id_ed25519"];
    age.keyFile = "/home/lua/.config/sops/age/keys.txt";
    secrets = {
      hashedPassword.neededForUsers = true;
    };
  };

  users.users.lua = {
    isNormalUser = true;
    description = "Lua";
    hashedPasswordFile = config.sops.secrets.hashedPassword.path;
    extraGroups = ["networkmanager" "wheel"];
    packages = [];
  };

  home-manager = {
    backupFileExtension = "back";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  };
}
