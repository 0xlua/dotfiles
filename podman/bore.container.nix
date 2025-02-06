{config, ...}: {
  sops.secrets.boreSecret = {};
  sops.templates."bore-env".content = ''
    BORE_SECRET=${config.sops.placeholder.boreSecret}
  '';

  virtualisation.oci-containers.containers.bore = {
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
}
