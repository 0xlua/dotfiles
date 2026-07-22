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
    userName = "lua@lua.one";
    email = "moin@lua.one";
    host = "mail.lua.one";
    passwordCommand = "cat ${config.sops.secrets."stalwart_app_token".path}";
  in
    lib.mkIf cfg.enable {
      sops.secrets."stalwart_app_token".mode = "0440";

      programs.gpg = {
        enable = true;
        settings.encrypt-to = email;
      };

      services.gpg-agent = {
        enable = true;
        pinentry = {
          package = pkgs.wayprompt;
          program = "pinentry-wayprompt";
        };
      };

      services.pimsync.enable = true;

      programs.pimsync.enable = true;

      programs.aerc = {
        enable = true;
        extraConfig = {
          hooks.mail-received = "notify-send \"New mail from $AERC_FROM_NAME\" \"$AERC_SUBJECT\"";
          compose.address-book-cmd = "khard email --parsable --remove-first-line %s";
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
            "mailnews.display.prefer_plaintext" = true; # view message body as plain text
          };
        };
      };

      programs.khal = {
        enable = true;
        settings.default.highlight_event_days = true;
      };

      programs.khard.enable = true;

      accounts = {
        calendar = {
          basePath = ".calendars";
          accounts.lua = {
            remote = {
              type = "caldav";
              url = "https://${host}/.well-known/caldav";
              inherit userName;
              passwordCommand = lib.strings.splitString " " passwordCommand;
            };
            pimsync = {
              inherit (config.programs.pimsync) enable;
              extraRemoteStorageDirectives = [
                {
                  name = "collection_id_segment";
                  params = ["second-last"];
                }
              ];
              extraPairDirectives = [
                {
                  name = "collections";
                  params = ["all"];
                }
              ];
            };
            khal = {
              inherit (config.programs.khal) enable;
              addresses = [email];
              type = "discover";
              color = "dark green";
            };
            thunderbird = {
              # inherit (config.programs.thunderbird) enable;
              settings = id: {
                "calendar.registry.${id}.uri" = lib.mkForce "https://${host}/dav/cal/${lib.strings.escapeURL userName}/default";
              };
            };
          };
        };
        contact = {
          basePath = ".contacts";
          accounts.lua = {
            remote = {
              type = "carddav";
              url = "https://${host}/.well-known/carddav";
              inherit userName;
              passwordCommand = lib.strings.splitString " " passwordCommand;
            };
            pimsync = {
              inherit (config.programs.pimsync) enable;
              extraRemoteStorageDirectives = [
                {
                  name = "collection_id_segment";
                  params = ["second-last"];
                }
              ];
              extraPairDirectives = [
                {
                  name = "collections";
                  params = ["all"];
                }
              ];
            };
            khard = {
              inherit (config.programs.khard) enable;
              type = "discover";
            };
            khal = {
              # inherit (config.programs.khal) enable;
              addresses = [email];
              readOnly = true;
              color = "dark magenta";
            };
            # thunderbird = {inherit (config.programs.thunderbird) enable;};
          };
        };
        email.accounts.lua = {
          address = email;
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
              cache-blobs = false;
              check-mail = "1m";
            };
          };
        };
      };
    };
}
