{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  config = lib.mkIf config.home-modules.desktop.enable {
    sops.secrets."liberaSasl".mode = "0440";
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
      enable = true;
      settings = {
        buffer.channel.topic = {
          enabled = true;
        };
        servers.liberachat = {
          channels = [
            "#selfhosted"
            "#gamingonlinux"
            "#lobsters"
            "#nixos"
            "#homeassistant"
            "#jellyfin"
            "#firefox"
            "#neovim"
            "##cycling"
            "#halloy"
            "#voidlinux"
          ];
          nickname = "lua";
          server = "irc.libera.chat";
          sasl.plain = {
            username = "lua";
            password_file = config.sops.secrets."liberaSasl".path;
          };
        };
      };
    };
  };
}
