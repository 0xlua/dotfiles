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
    {nixpkgs.overlays = [inputs.nur.overlays.default];}
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
    defaultSopsFile = ../secrets.yaml;
    age.sshKeyPaths = ["/home/lua/.ssh/id_ed25519"];
    age.keyFile = "/home/lua/.config/sops/age/keys.txt";
    secrets = {
      hashedPassword.neededForUsers = true;
      "nas/username" = {};
      "nas/domain" = {};
      "nas/password" = {};
    };
    templates = {
      "smb-secrets" = {
        owner = "lua";
        content = ''
          username=${config.sops.placeholder."nas/username"}
          domain=${config.sops.placeholder."nas/domain"}
          password=${config.sops.placeholder."nas/password"}
        '';
      };
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
    users.lua = import ./home.nix;
  };

  environment.systemPackages = [pkgs.cifs-utils];

  fileSystems."/home/lua/nas" = {
    device = "//io.internal/lua";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=${config.sops.templates."smb-secrets".path},uid=1000,gid=100"];
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    polarity = "dark";
    fonts = {
      sizes.terminal = 16;
      serif = {
        package = pkgs.vollkorn;
        name = "Vollkorn";
      };
      sansSerif = {
        # package = pkgs.atkinson-hyperlegible;
        package = pkgs.inter;
        name = "Inter";
      };
      monospace = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
