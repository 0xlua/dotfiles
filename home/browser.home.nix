{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {nixpkgs.overlays = [inputs.nur.overlays.default];}
  ];
  home-manager.users.lua = {pkgs, ...}: {
    home.packages = [inputs.zen-browser.packages."x86_64-linux".default];
    programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {};
      policies = {
        Cookies.Behavior = "reject-foreign";
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
        DisableFormHistory = true;
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
        TranslateEnabled = false;
        PictureInPicture.Enabled = false;
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
          search = {
            default = "DuckDuckGo";
            force = true;
          };
          settings = {
            "network.proxy.socks" = "localhost";
            "network.proxy.socks_port" = 2280;
            "network.proxy.type" = 1;
            "network.proxy.socks5_remote_dns" = true;
            "network.proxy.socks_version" = 5;
          };
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [bitwarden ublock-origin multi-account-containers];
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
