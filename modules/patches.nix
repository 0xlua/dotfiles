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
  # Zotero 10 requires Firefox 140 ESR, which is EOL
  # Zotero 11 will upgrade to 153 ESR, this can be removed then
  modules.unfreePackages = ["firefox-esr-140-bin-unwrapped"];
  nixpkgs.config.permittedInsecurePackages = [
    "firefox-esr-140-bin-unwrapped-140.17.0esr"
  ];
}
