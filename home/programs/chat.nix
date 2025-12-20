{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  sops.secrets."liberaSasl".mode = "0440";
  programs.gurk-rs = {
    enable = true;
    settings = {
      signal_db_path = "${config.home.homeDirectory}/.local/share/gurk/signal-db";
      first_name_only = false;
      show_receipts = true;
      notifications = true;
      bell = true;
      colored_messages = false;
      default_keybindings = true;
      user.name = "Lukas";
      sqlite = {
        url = "sqlite://${config.home.homeDirectory}/.local/share/gurk/gurk.sqlite";
        _preserve_unencryped = false;
      };
    };
  };

  programs.halloy = {
    enable = true;
    settings = {
      buffer.channel.topic = {
        enabled = true;
      };
      servers.liberachat = {
        channels = ["#voidlinux"];
        nickname = "lua";
        server = "irc.libera.chat";
        sasl.plain = {
          username = "lua";
          password_file = config.sops.secrets."liberaSasl".path;
        };
      };
    };
  };
}
