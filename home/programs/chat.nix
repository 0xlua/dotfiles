{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  cfg = config.home-modules.desktop;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  config = lib.mkIf cfg.enable {
    sops.secrets."irc/soju".mode = "0440";

    home.packages = with pkgs; [
      rustdesk-flutter # remote desktop
    ];
    programs.gurk-rs = {
      enable = true;
      settings = {
        user.display_name = "Lukas";
      };
    };

    programs.halloy = {
      enable = !cfg.preferLessGuis;
      settings = {
        actions = {
          sidebar.buffer = "replace-pane";
          buffer = {
            click_channel_name = "replace-pane";
            click_highlight = "replace-pane";
            click_nickname = "replace-pane";
            join_channel = "replace-pane";
            local = "replace-pane";
            message_channel = "replace-pane";
            message_user = "replace-pane";
          };
        };
        buffer.channel.topic = {
          enabled = true;
        };
        servers.soju = {
          nickname = "lua";
          server = "irc.lua.one";
          port = 443;
          use_tls = true;
          use_websocket = true;
          websocket_path = "/socket";
          sasl.plain = {
            username = "lua";
            password_file = config.sops.secrets."irc/soju".path;
          };
        };
      };
    };
  };
}
