{...}: {
  virtualisation = {
    containers.enable = true;
    podman.enable = true;
    podman.defaultNetwork.settings.dns_enabled = true;
    podman.autoPrune.enable = true;
    podman.autoPrune.flags = ["--all"];
    oci-containers.backend = "podman";
  };
}
