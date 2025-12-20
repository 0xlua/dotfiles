{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.home-modules.development.languages.rust;
in {
  options.home-modules.development.languages.rust.enable = lib.mkEnableOption "rust tooling";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lld
      # wild
      rustc
      clang
      rust-analyzer
      rustfmt
    ];

    programs.cargo = {
      enable = true;
      settings = {
        target.x86_64-unknown-linux-gnu = {
          linker = "clang";
          rustflags = ["-C" "link-arg=--ld-path=ld.lld"];
        };
      };
    };
  };
}
