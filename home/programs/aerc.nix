{
  lib,
  config,
  ...
}: {
  programs.aerc = {
    enable = true;
    extraConfig = {
      hooks.mail-received = "notify-send \"New mail from $AERC_FROM_NAME\" \"$AERC_SUBJECT\"";
      compose.address-book-cmd = "khard email --parsable --remove-first-line %s";
      filters = {
        "text/plain" = "wrap -w 100 | colorize";
        "text/html" = "html | colorize";
        "text/calendar" = "calendar";
        "image/*" = "viu";
        ".headers" = "colorize";
      };
      openers = {
        "text/calendar" = "khal import";
        "text/html" = lib.getExe config.programs.firefox.package;
        "text/plain" = lib.getExe config.programs.helix.package;
        "application/pdf" = lib.getExe config.programs.zathura.package;
        "video/*" = lib.getExe config.programs.mpv.package;
        "image/*" = lib.getExe config.programs.imv.package;
      };
      general = {
        unsafe-accounts-conf = true;
        pgp-provider = lib.mkIf config.home-modules.gpg.enable "gpg";
        use-terminal-pinentry = true;
      };
    };
    extraBinds = {
      global = {
        "gp" = ":prev-tab<Enter>";
        "gn" = ":next-tab<Enter>";
        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
        "<C-t>" = ":term<Enter>";
        "?" = ":help keys<Enter>";
        "<C-c>" = ":prompt 'Quit?' quit<Enter>";
        "<C-q>" = ":prompt 'Quit?' quit<Enter>";
        "<C-z>" = ":suspend<Enter>";
      };

      messages = {
        "q" = ":prompt 'Quit?' quit<Enter>";
        "." = ":repeat";
        "j" = ":next<Enter>";
        "<C-d>" = ":next 50%<Enter>";
        "<C-f>" = ":next 100%<Enter>";
        "k" = ":prev<Enter>";
        "<C-u>" = ":prev 50%<Enter>";
        "<C-b>" = ":prev 100%<Enter>";
        "gg" = ":select 0<Enter>";
        "ge" = ":select -1<Enter>";
        "J" = ":next-folder<Enter>";
        "K" = ":prev-folder<Enter>";
        "H" = ":collapse-folder<Enter>";
        "L" = ":expand-folder<Enter>";
        "tf" = ":toggle-folder<Enter>";
        "v" = ":mark -t<Enter>";
        "x" = ":mark -t<Enter>:next<Enter>";
        "V" = ":mark -v<Enter>";
        "T" = ":toggle-threads<Enter>";
        "zc" = ":fold<Enter>";
        "zo" = ":unfold<Enter>";
        "za" = ":fold -t<Enter>";
        "zM" = ":fold -a<Enter>";
        "zR" = ":unfold -a<Enter>";
        "<tab>" = ":fold -t<Enter>";
        "zz" = ":align center<Enter>";
        "zt" = ":align top<Enter>";
        "zb" = ":align bottom<Enter>";
        "<Enter>" = ":view<Enter>";
        "d" = ":choose -o y 'Really delete this message' delete-message<Enter>";
        "D" = ":delete<Enter>";
        "a" = ":archive flat<Enter>";
        "A" = ":unmark -a<Enter>:mark -T<Enter>:archive flat<Enter>";
        "C" = ":compose<Enter>";
        "m" = ":compose<Enter>";
        "b" = ":bounce<space>";
        "rr" = ":reply -a<Enter>";
        "rq" = ":reply -aq<Enter>";
        "Rr" = ":reply<Enter>";
        "Rq" = ":reply -q<Enter>";
        "c" = ":cf<space>";
        "$" = ":term<space>";
        "!" = ":term<space>";
        "|" = ":pipe<space>";
        "/" = ":search<space>";
        "\\" = ":filter<space>";
        "n" = ":next-result<Enter>";
        "N" = ":prev-result<Enter>";
        "<Esc>" = ":clear<Enter>";
        "s" = ":split<Enter>";
        "S" = ":vsplit<Enter>";
        "pl" = ":patch list<Enter>";
        "pa" = ":patch apply <Tab>";
        "pd" = ":patch drop <Tab>";
        "pb" = ":patch rebase<Enter>";
        "pt" = ":patch term<Enter>";
        "ps" = ":patch switch <Tab>";
      };

      "messages:folder=Drafts"."<Enter>" = ":recall<Enter>";

      view = {
        "/" = ":toggle-key-passthrough<Enter>/";
        "q" = ":close<Enter>";
        "O" = ":open<Enter>";
        "o" = ":open<Enter>";
        "S" = ":save<space>";
        "|" = ":pipe<space>";
        "D" = ":delete<Enter>";
        "A" = ":archive flat<Enter>";
        "<C-y>" = ":copy-link <space>";
        "<C-l>" = ":open-link <space>";
        "f" = ":forward<Enter>";
        "rr" = ":reply -a<Enter>";
        "rq" = ":reply -aq<Enter>";
        "Rr" = ":reply<Enter>";
        "Rq" = ":reply -q<Enter>";
        "H" = ":toggle-headers<Enter>";
        "<C-k>" = ":prev-part<Enter>";
        "<C-j>" = ":next-part<Enter>";
        "J" = ":next<Enter>";
        "K" = ":prev<Enter>";
      };

      "view::passthrough" = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "<Esc>" = ":toggle-key-passthrough<Enter>";
      };

      compose = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "$complete" = "<C-o>";
        "<C-k>" = ":prev-field<Enter>";
        "<C-j>" = ":next-field<Enter>";
        "<A-p>" = ":switch-account -p<Enter>";
        "<A-n>" = ":switch-account -n<Enter>";
        "<tab>" = ":next-field<Enter>";
        "<backtab>" = ":prev-field<Enter>";
        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
      };

      "compose::editor" = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "<C-k>" = ":prev-field<Enter>";
        "<C-j>" = ":next-field<Enter>";
        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
      };

      "compose::review" = {
        "y" = ":send<Enter>"; # Send
        "n" = ":abort<Enter>"; # Abort (discard message, no confirmation)
        "s" = ":sign<Enter>"; # Toggle signing
        "x" = ":encrypt<Enter>"; # Toggle encryption to all recipients
        "v" = ":preview<Enter>"; # Preview message
        "p" = ":postpone<Enter>"; # Postpone
        "q" = ":choose -o d discard abort -o p postpone postpone<Enter>"; # Abort or postpone
        "e" = ":edit<Enter>"; # Edit (body and headers)
        "a" = ":attach<space>"; # Add attachment
        "d" = ":detach<space>"; # Remove attachment
      };

      "terminal" = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
      };
    };
  };
}
