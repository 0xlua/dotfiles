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
