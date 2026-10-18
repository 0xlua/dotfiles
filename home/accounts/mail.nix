{
  config,
  lib,
  ...
}:
lib.mkIf config.home-modules.mail {
  accounts.email.accounts = let
    realName = "Luks Jordan";
  in {
    lua = let
      userName = "lua@lua.one";
      address = "moin@lua.one";
      host = "mail.lua.one";
      passwordCommand = "cat ${config.sops.secrets."stalwart_app_token".path}";
    in {
      inherit userName realName address passwordCommand;
      primary = true;
      jmap.host = "${host}/.well-known/jmap";
      imap = {
        inherit host;
        port = 993;
      };
      smtp = {
        inherit host;
        port = 465;
      };
      gpg = lib.mkIf config.home-modules.gpg.enable {
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
          "mail.identity.id_${id}.attachPgpKey" = config.home-modules.gpg.enable;
          "mail.identity.id_${id}.protectSubject" = false;
          "mail.identity.id_${id}.compose_html" = false;
          "mail.identity.id_${id}.reply_on_top" = true;
        };
        profiles = ["lua"];
      };
      aerc = {
        inherit (config.programs.aerc) enable;
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
    mailbox = let
      address = "hi@lukasjordan.com";
      host = "mailbox.org";
    in {
      inherit address realName;
      userName = address;
      passwordCommand = "cat ${config.sops.secrets."mailbox_app_token".path}";
      imap = {
        host = "imap.${host}";
        port = 993;
      };
      smtp = {
        host = "smtp.${host}";
        port = 465;
      };
      aerc = {
        inherit (config.programs.aerc) enable;
      };
      gpg = lib.mkIf config.home-modules.gpg.enable {
        key = "F49C2A49F161077C";
        signByDefault = true;
        encryptByDefault = true;
      };
      folders.inbox = "INBOX";
    };
  };
}
