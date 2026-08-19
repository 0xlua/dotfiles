{...}: {
  imports = [./hardware-configuration.nix];

  modules = {
    hostname = "galileo";
    user.name = "lua";
    roles = {
      vps.enable = true;
      server = {
        enable = true;
        atuin.enable = true;
        # podman-backup.enable = true;
        bore-server.enable = true;
        caddy.enable = true; # TODO: make Caddyfile config option
        kitchenowl.enable = true;
        linkding.enable = true;
        littlelink.enable = true;
        miniflux.enable = true;
        pocket-id.enable = true;
        rustypaste.enable = true;
        soju.enable = true;
        stalwart.enable = true;
        upvoterss.enable = true;
        vaultwarden.enable = true;
      };
    };
  };

  system.stateVersion = "24.05"; # Don't change
}
