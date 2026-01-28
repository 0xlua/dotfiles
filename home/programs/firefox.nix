{
  pkgs,
  inputs,
  config,
  ...
}: {
  stylix.targets.firefox.profileNames = ["default" "desy"];
  xdg.configFile."tridactyl/tridactylrc".source = ../../files/tridactylrc;
  xdg.mimeApps.associations.added = {"application/pdf" = ["firefox.desktop"];};
  xdg.mimeApps.defaultApplications."application/json" = ["firefox.desktop"];
  programs.firefox = {
    enable = config.home-modules.desktop.enable;
    package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {};
    nativeMessagingHosts = [pkgs.tridactyl-native];
    policies = {
      DisplayMenuBar = "never";
      SearchBar = "unified";
      TranslateEnabled = false;
      PictureInPicture.Enabled = false;
      GenerativeAI.Enabled = false;
      Preferences = {
        "widget.gtk.libadwaita-colors.enabled" = false; # allow native styling
        "layout.css.prefers-color-scheme.content-override" = 0; # dark mode
        "sidebar.verticalTabs" = true;
        "sidebar.visibility" = "hide-sidebar";
        "browser.newtabpage.pinned" = [];
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
        # re-enable native messaging (https://codeberg.org/celenity/Phoenix/commit/bb82bd987d8a5347d1d7213ffb8820298d51a52f)
        "webextensions.native-messaging.max-input-message-bytes" = 1048576;
        "webextensions.native-messaging.max-output-message-bytes" = 999999999;
      };
    };
    profiles = {
      default = {
        isDefault = true;
        search = {
          default = "ddg";
          force = true;
        };
        extensions.packages = with inputs.firefox-addons.packages.x86_64-linux; [bitwarden ublock-origin linkding-extension tridactyl];
      };
      desy = {
        id = 1;
        bookmarks.force = true;
        bookmarks.settings = [
          {
            toolbar = true;
            bookmarks = [
              {
                url = "https://mail.desy.de/";
                name = "Mail";
              }
              {
                url = "https://chat.desy.de/";
                name = "Chat";
              }
              {
                url = "https://syncandshare.desy.de/";
                name = "Sync & Share";
              }
              {
                url = "https://rt-system.desy.de/";
                name = "RT";
              }
              {
                url = "https://www.desy.de/~ucoxwiki/PRkTMFwbOIUGoUd/";
                name = "Migrationstabelle";
              }
              {
                url = "https://git.xwikisas.com/xwiki-sas-cpt/desy/-/issues";
                name = "XWiki Issues";
              }
              {
                url = "https://it-xwiki-tst.desy.de/xwiki/bin/view/Main/";
                name = "XWiki Test";
              }
              {
                url = "https://xwiki.desy.de/xwiki/bin/view/Main/";
                name = "XWiki Prod";
              }
            ];
          }
        ];
        isDefault = false;
        search = {
          default = "ddg";
          force = true;
        };
        settings = {
          "network.proxy.socks" = "localhost";
          "network.proxy.socks_port" = 2280;
          "network.proxy.type" = 1;
          "network.proxy.socks5_remote_dns" = true;
          "network.proxy.socks_version" = 5;
        };
        extensions.packages = with inputs.firefox-addons.packages.x86_64-linux; [bitwarden ublock-origin tridactyl];
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
}
