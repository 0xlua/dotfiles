# The purpose of this file is to collect the various patches/fixes for failing builds in on place,
# instead of putting them inline with the normal config.
# That helps keeping the config clean and with keeping track of the fixes,
# so I can remove them, once the fix is in upstream.
{
  pkgs,
  lib,
  config,
  ...
}: {
  # Wayprompt depended on an old Zig version, that is no longer included in nix.
  # This overlay uses a port to a newer zig version. Credit https://github.com/NixOS/nixpkgs/issues/545176#issuecomment-5097415975
  # Two options, to resolve this:
  # - Fixed Wayprompt build:  https://github.com/NixOS/nixpkgs/issues/545176
  # - pinentry-egui: https://github.com/NixOS/nixpkgs/pull/546505
  # Note: The tty fallback doesn't work with this port
  nixpkgs.overlays = [
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

  # fwupd didn't work with secure boot
  # Credit: https://github.com/nix-community/lanzaboote/pull/640
  # Upstream issues:
  # - lanzaboote: https://github.com/nix-community/lanzaboote/issues/591
  # - fwupd: https://github.com/fwupd/fwupd/issues/10202
  # - nixpkgs (maybe related): https://github.com/NixOS/nixpkgs/pull/524756
  services.fwupd.package = pkgs.fwupd.overrideAttrs (old: {
    mesonFlags =
      map (
        flag:
          if lib.hasPrefix "-Defi_app_location=" flag
          then "-Defi_app_location=/run/fwupd-efi"
          else flag
      )
      old.mesonFlags;
  });

  # niri pins libdisplay-info to v0.3.0, but nixpkgs only has v0.4.0
  # Credit: https://github.com/NixOS/nixpkgs/issues/545976#issuecomment-5084074580
  # I switched to https://github.com/epireyn/niri-flake, sodiboos flake seems no longer maintained
  # Using their binary cache should also resolve this
  home-manager.users.${config.modules.user.name} = lib.mkIf (config.modules.roles.desktop.compositor
    == "niri") {
    programs.niri.package = lib.mkForce (pkgs.niri.override {
      libdisplay-info = pkgs.libdisplay-info.overrideAttrs (finalAttrs: {
        version = "0.3.0";
        src = pkgs.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "emersion";
          repo = "libdisplay-info";
          rev = finalAttrs.version;
          sha256 = "sha256-nXf2KGovNKvcchlHlzKBkAOeySMJXgxMpbi5z9gLrdc=";
        };
      });
    });
  };

  # lact build failure
  # upstream issue: https://github.com/NixOS/nixpkgs/issues/546141
  services.lact.enable = lib.mkForce false;
}
