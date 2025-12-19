{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.modules.gaming.enable = lib.mkEnableOption "gaming";

  config = lib.mkIf cfg.gaming.enable {
    nixpkgs.config.allowUnfree = true;

    home-manager.users.lua = {pkgs, ...}: {
      home.packages = with pkgs; [
        lact
        mumble
        teamspeak6-client
        chess-tui
        # bottles
        # mangohud
      ];
      programs.discord = {
        enable = true;
        package = pkgs.discord-ptb;
      };
    };

    programs.corectrl = {
      enable = true;
    };

    hardware.amdgpu.overdrive.enable = true;

    programs.gamemode = {
      enable = true;
      settings.general.inhibit_screensaver = 0;
    };

    users.users.lua.extraGroups = ["gamemode"];

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    programs.steam = {
      enable = true;
      # extest.enable = true; # steam input wayland compat
      gamescopeSession = {
        enable = true;
        args = [
          "--adaptive-sync"
          "--hdr-enabled"
          # "--mangoapp"
          "--rt"
        ];
      };
      extraCompatPackages = with pkgs; [proton-ge-bin];
    };

    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
