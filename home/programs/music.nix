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
      # network.listenAddress = "/run/mpd/socket";
      network.listenAddress = "@mpd";
      extraConfig = ''
        audio_output {
          type  "pipewire"
          name  "PipeWire Sound Server"
        }'';
    };

    services.mpdris2-rs = {
      enable = true;
      host = config.services.mpd.network.listenAddress;
      notifications.enable = true;
    };

    programs.rmpc = {
      enable = true;
      config = ''
        (
          cache_dir: Some("${config.xdg.cacheHome}/rmpc"),
          address: "${config.services.mpd.network.listenAddress}",
        )
      '';
    };
  };
}
