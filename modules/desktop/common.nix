{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./niri.nix
    ./cosmic.nix
  ];

  options.modules.desktop = {
    enable = lib.mkEnableOption "a graphic desktop";
    compositor = lib.mkOption {
      type = with lib.types; nullOr (enum ["cosmic" "niri"]);
      default = null;
      example = "cosmic";
      description = "What desktop envrionment to use";
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [inputs.eilmeldung.overlays.default];
    sops = {
      secrets = {
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

    environment.systemPackages = [pkgs.cifs-utils];

    stylix.image = ../../files/wallpaper/city.jpg;

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        wayland
        libxkbcommon
        zlib
        zstd
        stdenv.cc.cc
        curl
        openssl
        attr
        libssh
        bzip2
        libxml2
        acl
        libsodium
        util-linux
        xz
        systemd
        glibc
        libGL
        patchelf
      ];
    };

    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    programs.virt-manager.enable = true;
    virtualisation.libvirtd.enable = true;
    users.groups.libvirtd.members = ["lua"];

    fileSystems."/home/lua/nas" = {
      device = "//io.internal/lua";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in ["${automount_opts},credentials=${config.sops.templates."smb-secrets".path},uid=1000,gid=100"];
    };

    fileSystems."/home/lua/paperless_inbox" = {
      device = "//io.internal/scanner";
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

    services.fwupd.enable = true;

    stylix = {
      polarity = "dark";
      fonts = {
        sizes.terminal = 16;
        serif = {
          package = pkgs.vollkorn;
          name = "Vollkorn";
        };
        sansSerif = {
          package = pkgs.inter;
          name = "Inter";
          # package = pkgs.atkinson-hyperlegible-next;
          # name = "Atkinson Hyperlegible Next";
        };
        monospace = {
          package = pkgs.maple-mono.NF-unhinted;
          name = "Maple Mono NF";
          # package = pkgs.nerd-fonts.hack;
          # name = "Hack Nerd Font";
          # package = pkgs.nerd-fonts.atkynson-mono;
          # name = "Atkinson Hyperlegible Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  };
}
