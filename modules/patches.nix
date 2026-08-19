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
}
