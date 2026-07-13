{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  stylix.targets.firefox.profileNames = ["default"];

  xdg = {
    configFile."tridactyl/tridactylrc".source = ../../files/tridactylrc;
    mimeApps = {
      associations.added = {"application/pdf" = ["firefox.desktop"];};
      defaultApplications."application/json" = ["firefox.desktop"];
    };
  };

  programs.firefox = {
    inherit (config.home-modules.desktop) enable;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    nativeMessagingHosts = [pkgs.tridactyl-native];
    policies = {
      DisplayMenuBar = "never";
      SearchBar = "unified";
      TranslateEnabled = false;
      PictureInPicture.Enabled = false;
      "3rdparty".Extensions = {
        "uBlock0@raymondhill.net".adminSettings = {
          userSettings = rec {
            advancedUserEnabled = true;
            externalLists = lib.concatStringsSep "\n" importedLists;
            firewallPaneMinimized = false;
            importedLists = ["https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"];
            popupPanelSections = 31;
          };
          selectedFilterLists = [
            "user-filters"
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-quick-fixes"
            "ublock-unbreak"
            "easylist"
            "easyprivacy"
            "adguard-spyware-url"
            "urlhaus-1"
            "plowe-0"
            "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
          ];
          hostnameSwitchesString = lib.concatStringsSep "\n" [
            "no-large-media: behind-the-scene false"
            "no-csp-reports: * true"
            "no-scripting: マリウス.com true"
            "* * 3p-script block"
            "* * 3p-frame block"
          ];
        };
      };
    };
    globalExtensions = with inputs.firefox-addons.packages.x86_64-linux; [bitwarden ublock-origin linkding-extension tridactyl libredirect];
    profiles.default = {
      isDefault = true;
      settings = {
        "widget.gtk.libadwaita-colors.enabled" = false; # allow native styling
        "layout.css.prefers-color-scheme.content-override" = 0; # dark mode
        "sidebar.verticalTabs" = true;
        "sidebar.visibility" = "hide-sidebar";
        "browser.newtabpage.pinned" = [];
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
        # re-enable native messaging (https://codeberg.org/celenity/Phoenix/commit/bb82bd987d8a5347d1d7213ffb8820298d51a52f)
        "webextensions.native-messaging.max-input-message-bytes" = 1048576;
        "webextensions.native-messaging.max-output-message-bytes" = 2147483647;
      };
      search = {
        default = "ddg";
        force = true;
      };
    };
  };
}
