{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.server;
in {
  options.server.enable = lib.mkEnableOption "Server role incl. Podman";

  config = lib.mkIf cfg.enable {
    programs.fish.enable = true;
    users.users = {
      root.hashedPassword = "*";
      lua = {
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFXnCtIbRMHYs6zmB/LNqARTJbIK+SWMpghHIDBJ7hiS"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJlfUoi3tLKbWSaqrGbqy76GbeDua/LZvOVkSGfX1J2p"
        ];
      };
    };
    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        AllowUsers = ["lua"];
        UseDns = true;
        PermitRootLogin = "no";
      };
    };
    virtualisation = {
      containers.enable = true;
      podman.enable = true;
      podman.defaultNetwork.settings.dns_enabled = true;
      podman.autoPrune.enable = true;
      podman.autoPrune.flags = ["--all"];
      oci-containers.backend = "podman";
    };
    nix.settings.auto-optimise-store = true;

    nix.gc = {
      automatic = true;
      options = "--delete-older-than 14d";
      dates = "Fri 04:00 Europe/Berlin";
    };

    systemd = {
      services.clear-log = {
        description = "Clear >1 month-old logs every week";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=30d";
        };
      };
      timers.clear-log = {
        wantedBy = ["timers.target"];
        partOf = ["clear-log.service"];
        timerConfig.OnCalendar = "weekly Europe/Berlin";
      };
    };

    programs.rust-motd = {
      enable = true;
      settings = {
        banner = {
          color = "magenta";
          command = "${pkgs.figlet}/bin/figlet -f slant ${config.networking.hostName}";
        };
        cg_stats = {
          state_file = "cg_stats.toml";
          threshold = 0.01;
        };
        service_status = {}; # filled by the services themselves
        uptime.prefix = "Up";
        load_avg.format = "Load (1, 5, 15 min.): {one:.02}, {five:.02}, {fifteen:.02}";
        memory.swap_pos = "none";
        last_login = {
          lua = 3;
          root = 1;
        };
        filesystems = {
          root = "/";
        };
        last_run = {};
      };
    };
  };
}
