{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
  ];

  options.modules = {
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "galileo";
      description = "Set the system hostname";
    };
    kernel = lib.mkOption {
      type = lib.types.raw;
      default = pkgs.linuxPackages_latest;
      example = pkgs.linuxPackages_latest;
      description = "Which kernel to use";
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
    nix = {
      settings.experimental-features = "nix-command flakes";
      extraOptions = ''
        trusted-users = root ${cfg.user.name}
      '';
    };

    boot = {
      kernelPackages = cfg.kernel;
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
    console = {inherit (cfg) keyMap;};

    security.sudo-rs.enable = true;

    networking = {
      hostName = cfg.hostname; # Define your hostname.
      networkmanager.enable = true; # Enable networking
      nftables.enable = true;
    };

    sops = let
      inherit (config.users.users.${cfg.user.name}) home;
    in {
      defaultSopsFile = ../secrets.yaml;
      age.sshKeyPaths = ["${home}/.ssh/id_ed25519" "/etc/ssh/ssh_host_ed25519_key"];
      age.keyFile = "${home}/.config/sops/age/keys.txt";
      secrets = {
        hashedPassword.neededForUsers = true;
      };
    };

    programs.fish.enable = true;

    users = {
      mutableUsers = false;
      users.${cfg.user.name} = {
        inherit (config.modules.user) shell;
        uid = lib.mkDefault 1000;
        isNormalUser = true;
        description = cfg.user.desc;
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
      users.${cfg.user.name} = ./home.nix;
    };

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-gray.yaml";
    };
  };
}
