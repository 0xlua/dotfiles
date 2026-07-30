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
    nixpkgs.overlays = [
      inputs.eilmeldung.overlays.default
      (final: prev: {
        wayprompt = let
          version = "0.1.2-mzte.2";
          src = final.fetchFromGitea {
            domain = "git.mzte.de";
            owner = "LordMZTE";
            repo = "wayprompt";
            tag = "v${version}";
            hash = "sha256-uVkeLJgvdc6c7xmNUdWlUS1f3fx8cCIV/raw2prP4O4=";
          };
          deps = final.zig_0_16.fetchDeps {
            inherit version src;
            pname = "wayprompt";
            hash = "sha256-j1SrpUFgrtcv2pf43ZxRo3poYtMDQnWS3vmKkU5trE0=";
          };
        in
          prev.wayprompt.overrideAttrs {
            inherit version src;

            nativeBuildInputs = with final; [
              zig_0_16
              pkg-config
              wayland
              wayland-scanner
              scdoc
            ];

            zigBuildFlags = [];

            preBuild = ''
              ln -sf "${deps}" "$ZIG_GLOBAL_CACHE_DIR/p"
            '';
          };
      })
    ];

    stylix.image = ../../files/wallpaper/patagonia.jpg;

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

    modules.samba = {
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
          source = "//io.internal/lua";
          target = "/home/lua/nas";
          inherit specialOptions;
        }
        {
          source = "//io.internal/scanner";
          target = "/home/lua/paperless_inbox";
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

    services.fwupd = {
      enable = true;
      package = pkgs.fwupd.overrideAttrs (old: {
        mesonFlags =
          map (
            flag:
              if lib.hasPrefix "-Defi_app_location=" flag
              then "-Defi_app_location=/run/fwupd-efi"
              else flag
          )
          old.mesonFlags;
      });
    };

    services.udisks2.enable = true;

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
