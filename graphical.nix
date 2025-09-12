{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    secrets = {
      "nas/username" = {};
      "nas/domain" = {};
      "nas/password" = {};
    };
    templates = {
      "smb-secrets" = {
        owner = "lua";
        content = ''
          username=${config.sops.placeholder."nas/username"}
          domain=${config.sops.placeholder."nas/domain"}
          password=${config.sops.placeholder."nas/password"}
        '';
      };
    };
  };

  environment.systemPackages = [pkgs.cifs-utils];

  fileSystems."/home/lua/nas" = {
    device = "//io.internal/lua";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=${config.sops.templates."smb-secrets".path},uid=1000,gid=100"];
  };

  fileSystems."/home/lua/paperless_inbox" = {
    device = "//io.internal/scanner";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=${config.sops.templates."smb-secrets".path},uid=1000,gid=100"];
  };

  security.rtkit.enable = true;

  # Needed for localsend
  networking.firewall = {
    allowedTCPPorts = [53317];
    allowedUDPPorts = [53317];
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  stylix = {
    polarity = "dark";
    fonts = {
      sizes.terminal = 16;
      serif = {
        package = pkgs.vollkorn;
        name = "Vollkorn";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
        # package = pkgs.atkinson-hyperlegible-next;
        # name = "Atkinson Hyperlegible Next";
      };
      monospace = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font";
        # package = pkgs.nerd-fonts.atkynson-mono;
        # name = "Atkinson Hyperlegible Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
