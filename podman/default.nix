{...}: {
  # TODO: Import *.container.nix
  imports = [
    ./backup.container.nix
    ./bore.container.nix
    ./caddy.container.nix
    ./kitchenowl.container.nix
    ./linkding.container.nix
    ./littlelink.container.nix
    ./miniflux.container.nix
    ./ocular.container.nix
    ./podfetch.container.nix
    ./redlib.container.nix
    ./rustypaste.container.nix
    ./stalwart.container.nix
    ./vaultwarden.container.nix
  ];
  virtualisation = {
    containers.enable = true;
    podman.enable = true;
    podman.defaultNetwork.settings.dns_enabled = true;
    podman.autoPrune.enable = true;
    podman.autoPrune.flags = ["--all"];
    oci-containers.backend = "podman";
  };
}
