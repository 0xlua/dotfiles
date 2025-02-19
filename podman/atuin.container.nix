{config, ...}: {
  sops.secrets."atuin/db" = {};
  sops.secrets."atuin/password" = {};
  sops.secrets."atuin/user" = {};
  sops.templates."atuin-env".content = ''
    ATUIN_DB_URI=postgres://${config.sops.placeholder."atuin/user"}:${config.sops.placeholder."atuin/password"}@atuin-db/${config.sops.placeholder."atuin/db"}?sslmode=disable
  '';

  virtualisation.oci-containers.containers = {
    atuin = {
      image = "ghcr.io/atuinsh/atuin:v18.4.0";
      autoStart = true;
      dependsOn = ["atuin-db"];
      cmd = ["server" "start"];
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      environmentFiles = [
        config.sops.templates."atuin-env".path
      ];
      environment = {
        ATUIN_HOST = "0.0.0.0";
        ATUIN_OPEN_REGISTRATION = "true";
      };
    };
    atuin-db = {
      image = "docker.io/postgres:17-alpine";
      environment = {
        POSTGRES_USER_FILE = "/run/secrets/user";
        POSTGRES_PASSWORD_FILE = "/run/secrets/password";
        POSTGRES_DB_FILE = "/run/secrets/db";
      };
      volumes = [
        "atuin:/var/lib/postgresql/data"
        "${config.sops.secrets."atuin/password".path}:/run/secrets/password"
        "${config.sops.secrets."atuin/user".path}:/run/secrets/user"
        "${config.sops.secrets."atuin/db".path}:/run/secrets/db"
      ];
    };
  };
}
