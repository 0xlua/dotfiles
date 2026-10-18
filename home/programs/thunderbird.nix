{
  config,
  pkgs,
  ...
}: {
  programs.thunderbird = {
    enable = !config.home-modules.desktop.preferLessGuis;
    package = pkgs.thunderbird-latest;
    profiles.lua = {
      isDefault = true;
      withExternalGnupg = true;
      search = {
        default = "ddg";
        force = true;
      };
      settings = {
        "calendar.week.start" = 1; # Start Week on Monday
        "mail.openpgp.fetch_pubkeys_from_gnupg" = config.home-modules.gpg.enable; # Import public keys from host gpg
        "general.autoScroll" = true; # Enable Auto-Scroll
        "mail.threadpane.listview" = 1; # Show Messages in list view
        "mail.default_send_format" = 1; # compose messages in plain text
        "network.cookie.cookieBehavior" = 2; # don't accept any cookies
        "privacy.donottrackheader.enabled" = true; # send DNT Header
        "datareporting.healthreport.uploadEnabled" = false; # Don't send telemetry to mozilla
        "mail.e2ee.auto_enable" = true; # auto-encrypt mails
        "mail.identity.default.compose_html" = false;
        "mailnews.display.prefer_plaintext" = true; # view message body as plain text
      };
    };
  };
}
