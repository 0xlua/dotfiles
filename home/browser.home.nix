{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {nixpkgs.overlays = [inputs.nur.overlays.default];}
  ];
  home-manager.users.lua = {pkgs, ...}: {
    programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {};
      policies = {
        DisableTelemetry = true;
        DisablefirefoxStudies = true;
        DisablePocket = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisplayBookmarksToolbar = "always";
        DisplayMenuBar = "never";
        SearchBar = "unified";
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        FirefoxHome = {
          Search = true;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = false;
        };
        Homepage = {
          URL = "https://start.duckduckgo.com";
          Locked = true;
          StartPage = "homepage-locked";
        };
        HttpsOnlyMode = "enabled";
        OfferToSaveLogins = false;
        ShowHomeButton = true;
        Preferences = {
          "browser.contentblocking.category" = "strict";
          "general.autoScroll" = true;
          "extensions.autoDisableScopes" = 0;
        };
      };
      profiles = {
        default = {
          isDefault = true;
          search = {
            default = "DuckDuckGo";
            force = true;
          };
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [bitwarden ublock-origin linkding-extension];
        };
        desy = {
          id = 1;
          isDefault = false;
          containersForce = true;
          containers = {
            admin = {
              id = 1;
              color = "red";
            };
            default = {
              id = 2;
              color = "green";
            };
          };
        };
      };
    };
  };
}
