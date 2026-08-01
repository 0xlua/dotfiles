{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.roles.desktop;
in {
  imports = [
    ./niri.nix
    ./cosmic.nix
    ./gaming.nix
  ];

  options.modules.roles.desktop = {
    enable = lib.mkEnableOption "the desktop role";
    compositor = lib.mkOption {
      type = lib.types.enum ["none" "cosmic" "niri"];
      default = "none";
      example = "cosmic";
      description = "What desktop envrionment to use. `none` installs no compositor and only relies on the tty";
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [inputs.eilmeldung.overlays.default];

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

    programs.yubikey-manager = {
      enable = cfg.compositor != "none";
      package = pkgs.yubioath-flutter;
    };

    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    programs.virt-manager.enable = true;
    virtualisation.libvirtd.enable = true;
    users.groups.libvirtd.members = [config.modules.user.name];

    modules.samba = let
      user = config.modules.user.name;
      inherit (config.users.users.${user}) home;
    in {
      enable = true;
      mounts = let
        specialOptions = [
          "noauto"
          "x-systemd.idle-timeout=60"
          "x-systemd.device-timeout=5s"
          "x-systemd.mount-timeout=5s"
        ];
      in [
        {
          source = "//io.internal/${user}";
          target = "${home}/nas";
          inherit specialOptions;
        }
        {
          source = "//io.internal/scanner";
          target = "${home}/paperless_inbox";
          inherit specialOptions;
        }
      ];
    };

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.fwupd.enable = true;

    services.udisks2.enable = true;

    stylix = {
      image = ../../../files/wallpaper/patagonia.jpg;
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
