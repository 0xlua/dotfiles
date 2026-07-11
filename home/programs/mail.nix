{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.home-modules.mail;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  options.home-modules.mail.enable = lib.mkEnableOption "mail";

  config = let
    userName = "moin@lua.one";
    host = "mail.lua.one";
    passwordCommand = "cat ${config.sops.secrets."stalwart_app_token".path}";
  in
    lib.mkIf cfg.enable {
      sops.secrets."stalwart_app_token".mode = "0440";

      programs.gpg = {
        enable = true;
        settings.encrypt-to = userName;
      };

      services.gpg-agent = {
        enable = true;
        pinentry = {
          package = pkgs.wayprompt;
          program = "pinentry-wayprompt";
        };
      };

      programs.aerc = {
        enable = true;
        extraConfig = {
          hooks.mail-received = "notify-send \"New mail from $AERC_FROM_NAME\" \"$AERC_SUBJECT\"";
          filters = {
            "text/plain" = "colorize";
            "text/html" = "html | colorize";
          };
          general = {
            unsafe-accounts-conf = true;
            pgp-provider = "gpg";
            use-terminal-pinentry = true;
          };
        };
      };

      programs.thunderbird = {
        inherit (config.home-modules.desktop) enable;
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
            "mail.openpgp.fetch_pubkeys_from_gnupg" = true; # Import public keys from host gpg
            "general.autoScroll" = true; # Enable Auto-Scroll
            "mail.threadpane.listview" = 1; # Show Messages in list view
            "mail.default_send_format" = 1; # compose messages in plain text
            "network.cookie.cookieBehavior" = 2; # don't accept any cookies
            "privacy.donottrackheader.enabled" = true; # send DNT Header
            "datareporting.healthreport.uploadEnabled" = false; # Don't send telemetry to mozilla
            "mail.e2ee.auto_enable" = true; # auto-encrypt mails
            "mail.identity.default.compose_html" = false;
          };
        };
      };

      accounts = {
        calendar.accounts.lua = {
          primary = true;
          remote = {
            type = "caldav";
            url = "https://${host}/dav/cal/${lib.strings.escapeURL userName}/default";
            inherit userName passwordCommand;
          };
          thunderbird = {
            inherit (config.programs.thunderbird) enable;
          };
        };
        contact.accounts.lua = {
          remote = {
            type = "carddav";
            url = "https://${host}/dav/card/${lib.strings.escapeURL userName}/default";
            inherit userName passwordCommand;
          };
          thunderbird = {
            inherit (config.programs.thunderbird) enable;
          };
        };
        email.accounts.lua = {
          address = userName;
          inherit userName passwordCommand;
          primary = true;
          realName = "Lukas Jordan";
          jmap.host = "${host}/.well-known/jmap";
          imap = {
            inherit host;
            port = 993;
          };
          smtp = {
            inherit host;
            port = 465;
          };
          gpg = {
            # Note: In Thunderbird the Public Key also has to be imported: Key Manager -> Keyserver -> Discover Keys Online
            key = "0A8B4FCA78F832FA";
            signByDefault = true;
            encryptByDefault = true;
          };
          folders = {
            inbox = "Inbox";
            sent = "Sent Items";
            drafts = "Drafts";
            trash = "Deleted Items";
          };
          thunderbird = {
            inherit (config.programs.thunderbird) enable;
            settings = id: {
              "mail.identity.id_${id}.attachPgpKey" = true;
              "mail.identity.id_${id}.protectSubject" = false;
              "mail.identity.id_${id}.compose_html" = false;
              "mail.identity.id_${id}.reply_on_top" = true;
            };
            profiles = ["lua"];
          };
          aerc = {
            enable = true;
            extraAccounts = {
              source = lib.mkForce "jmap://${lib.strings.escapeURL userName}@${host}/.well-known/jmap";
              source-cred-cmd = passwordCommand;
              outgoing = lib.mkForce "jmap://";
              use-labels = true;
              cache-state = true;
              cache-blobs = false;
              check-mail = "1m";
            };
          };
        };
      };
    };
}
