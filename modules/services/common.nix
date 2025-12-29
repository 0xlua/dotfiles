{
  config,
  lib,
  ...
}: let
  cfg = config.server;
in {
  options.server.enable = lib.mkEnableOption "Server role incl. Podman";

  config = lib.mkIf cfg.enable {
    virtualisation = {
      containers.enable = true;
      podman.enable = true;
      podman.defaultNetwork.settings.dns_enabled = true;
      podman.autoPrune.enable = true;
      podman.autoPrune.flags = ["--all"];
      oci-containers.backend = "podman";
    };
  };
}
