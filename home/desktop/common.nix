{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home-modules.desktop;
in {
  options.home-modules.desktop = {
    enable = lib.mkEnableOption "a graphic desktop envrionment";
    preferLessGuis = lib.mkEnableOption "less GUI Apps";
    compositor = lib.mkOption {
      type = with lib.types; nullOr (enum ["cosmic" "niri"]);
      default = null;
      example = "cosmic";
      description = "What desktop envrionment to use";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wl-clipboard
      libnotify
      xwayland-satellite
    ];

    services.udiskie = {
      enable = true;
      settings = {
        # see https://github.com/nix-community/home-manager/issues/632
        program_options = {
          file_manager = "${pkgs.yazi}/bin/yazi";
          terminal = "${pkgs.ghostty}/bin/ghostty";
        };
      };
    };

    services.wpaperd.enable = true;

    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplicationPackages = [
        config.programs.zathura.package
        config.programs.firefox.package
        config.programs.yazi.package
        config.programs.helix.package
        config.programs.mpv.package
        pkgs.oculante
      ];
      defaultApplications."x-scheme-handler/mpv" = ["mpv.desktop"];
    };
  };
}
