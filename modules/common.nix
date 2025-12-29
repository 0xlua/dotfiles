{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [inputs.stylix.nixosModules.stylix];
  nix = {
    settings.experimental-features = "nix-command flakes";
    extraOptions = ''
      trusted-users = root lua
    '';
  };

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

  users.mutableUsers = false;

  security.sudo-rs.enable = true;

  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.sshKeyPaths = ["/home/lua/.ssh/id_ed25519" "/etc/ssh/ssh_host_ed25519_key"];
    age.keyFile = "/home/lua/.config/sops/age/keys.txt";
    secrets = {
      hashedPassword.neededForUsers = true;
    };
  };

  users.users.lua = {
    isNormalUser = true;
    description = "Lua";
    hashedPasswordFile = config.sops.secrets.hashedPassword.path;
    extraGroups = ["networkmanager" "wheel" "libvird"];
  };

  home-manager = {
    backupFileExtension = "back";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-gray.yaml";
  };
}
