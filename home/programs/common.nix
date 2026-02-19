{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.eilmeldung.homeManager.default
  ];

  home.packages = with pkgs; [
    # file viewer
    viu # images
    mdcat # md
    doxx # docx
    hygg # pdf
    xleak # xlsx

    # system
    dysk
    dua # disk usage

    # tools
    ouch # archiving
    managarr # *arr
    podman-tui
    magic-wormhole-rs

    # logs
    tailspin
    hl-log-viewer
  ];

  programs.eilmeldung = {
    enable = config.home-modules.desktop.enable;
    settings = {
      startup_commands = ["sync"];
      feed_list_scope = "unread";
      zen_mode_show_header = true;
      share_targets = [
        "clipboard"
        "mpv mpv {url}"
      ];
    };
  };

  sops.secrets."atuin/key".mode = "0440";

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      key_path = config.sops.secrets."atuin/key".path;
      update_check = false;
      sync_address = "https://atuin.lua.one";
      keymap_mode = "vim-insert";
      dotfiles.enabled = false;
      filter_mode = "host";
      inline_height = 20;
      enter_accept = false;
      filter_mode_shell_up_key_binding = "session";
    };
  };

  programs.bottom = {
    enable = true;
    settings = {
      flags = {
        temperature_type = "celsius";
        battery = true;
        disable_click = true;
        # color = "nord";
      };
    };
  };

  programs.broot.enable = false;

  programs.fzf.enable = true;

  programs.numbat.enable = true;

  programs.rbw = {
    enable = true;
    settings = {
      base_url = "https://vault.lua.one";
      email = "sec@lukasjordan.com";
      pinentry = pkgs.pinentry-tty;
    };
  };

  programs.television = {
    enable = false;
    settings.use_nerd_font_icons = true;
  };

  programs.nix-search-tv.enable = false;

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";
  };
}
