{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  config = lib.mkIf config.home-modules.desktop.enable {
    sops.secrets."spotify_client_id".mode = "0440";

    programs.spotify-player = {
      enable = true;
      settings = {
        client_id_command = {
          command = "cat";
          args = [config.sops.secrets."spotify_client_id".path];
        };
      };
    };

    services.mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/nas/Music";
      extraConfig = ''
        audio_output {
          type  "pipewire"
          name  "PipeWire Sound Server"
        }'';
    };

    programs.rmpc = {
      enable = true;
    };
  };
}
