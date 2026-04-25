{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.home-modules.llm;
in {
  options.home-modules.llm.enable = lib.mkEnableOption "LLM Tools like Ollama";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [pi-coding-agent];
    services.ollama = {
      enable = true;
      acceleration = "rocm";
    };
    programs.opencode = {
      enable = true;
    };
  };
}
