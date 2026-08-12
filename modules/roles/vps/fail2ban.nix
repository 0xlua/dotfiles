{
  lib,
  config,
  ...
}:
lib.mkIf config.modules.roles.vps.enable {
  environment.etc."fail2ban/filter.d/caddy-status.conf".text = lib.mkDefault (lib.mkAfter ''
    [Definition]
    failregex = ^.*"remote_ip":"<HOST>",.*?"status":(?:0|401|403|500|502),.*$
    ignoreregex =
    datepattern = LongEpoch
  '');

  services.fail2ban = {
    enable = true;
    jails = {
      caddy-status.settings = {
        port = "http,https";
        filter = "caddy-status";
        # logpath = "/home/lua/podman/caddy/logs/access.log"; # systemd service can't access /home
        enabled = true;
        backend = "systemd";
        journalmatch = "_SYSTEMD_UNIT=podman-caddy.service";
      };
    };
  };
  programs.rust-motd.settings.fail_2_ban.jails = ["sshd" "caddy-status"];
}
