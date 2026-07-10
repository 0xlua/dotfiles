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
    email = "moin@lua.one";
    host = "mail.lua.one";
    passwordCommand = "cat ${config.sops.secrets."stalwart_app_token".path}";
  in
    lib.mkIf cfg.enable {
      sops.secrets."stalwart_app_token".mode = "0440";

      programs.gpg = {
        enable = true;
        settings = {
          encrypt-to = email;
        };
      };

      services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.pinentry-tty;
      };

      programs.aerc = {
        enable = true;
        extraConfig = {
          hooks = {
            mail-received = "notify-send \"New mail from $AERC_FROM_NAME\" \"$AERC_SUBJECT\"";
          };
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
          settings = {
            "calendar.week.start" = 1;
          };
        };
      };

      accounts = {
        calendar.accounts.lua.remote = {
          type = "caldav";
          url = "https://${host}/.well-known/caldav";
          userName = email;
          inherit passwordCommand;
        };
        email.accounts.lua = {
          address = email;
          userName = email;
          inherit passwordCommand;
          primary = true;
          realName = "Lukas Jordan";
          jmap.host = "${host}/.well-known/jmap";
          gpg = {
            key = "";
            signByDefault = true;
            encryptByDefault = true;
          };
          folders = {
            inbox = "Inbox";
            sent = "Sent Items";
            drafts = "Drafts";
            trash = "Deleted Items";
          };
          # imap = {
          #   host = "mail.lua.one";
          #   port = 993;
          #   tls.enable = true;
          # };
          # smtp = {
          #   host = "mail.lua.one";
          #   port = 465;
          #   tls.enable = true;
          # };
          # thunderbird = {inherit (config.home-modules.desktop) enable;};
          aerc = {
            enable = true;
            extraAccounts = {
              source = "jmap://${lib.strings.escapeURL email}@${host}";
              source-cred-cmd = passwordCommand;
              outgoing = "jmap://";
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
