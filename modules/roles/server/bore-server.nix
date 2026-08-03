{
  config,
  lib,
  ...
}: let
  cfg = config.modules.roles.server.bore-server;
in {
  options.modules.roles.server.bore-server.enable = lib.mkEnableOption "bore server";

  config = lib.mkIf cfg.enable {
    sops.secrets.boreSecret = {};
    sops.templates."bore-env".content = ''
      BORE_SECRET=${config.sops.placeholder.boreSecret}
    '';

    programs.rust-motd.settings.service_status.bore-server = config.virtualisation.oci-containers.containers.bore-server.serviceName;

    networking.firewall.allowedTCPPorts = [7835]; # bore

    virtualisation.oci-containers.containers.bore-server = {
      image = "docker.io/ekzhang/bore:latest";
      cmd = ["server"];
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      environmentFiles = [
        config.sops.templates."bore-env".path
      ];
      ports = ["7835:7835"];
    };
  };
}
