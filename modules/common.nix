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

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure console keymap
  console.keyMap = lib.mkDefault "us";

  security.sudo-rs.enable = true;

  networking = {
    networkmanager.enable = true; # Enable networking
    nftables.enable = true;
  };

  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.sshKeyPaths = ["/home/lua/.ssh/id_ed25519" "/etc/ssh/ssh_host_ed25519_key"];
    age.keyFile = "/home/lua/.config/sops/age/keys.txt";
    secrets = {
      hashedPassword.neededForUsers = true;
    };
  };

  users = {
    mutableUsers = false;
    users.lua = {
      isNormalUser = true;
      description = "Lua";
      hashedPasswordFile = config.sops.secrets.hashedPassword.path;
      extraGroups = ["networkmanager" "wheel" "libvird"];
    };
  };

  home-manager = {
    backupFileExtension = "back";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit (config.networking) hostName;
    };
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-gray.yaml";
  };
}
