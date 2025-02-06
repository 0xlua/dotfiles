{...}: {
  virtualisation.oci-containers.containers.stalwart = {
    image = "docker.io/stalwartlabs/mail-server:latest";
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    ports = ["25:25" "465:465" "993:993"];
    volumes = [
      "/home/lua/podman/stalwart:/opt/stalwart-mail"
    ];
  };
}
