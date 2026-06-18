{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.home-modules.llm;
in {
  options.home-modules.llm = {
    enable = lib.mkEnableOption "LLM Tools like Ollama";
    modelPath = lib.mkOption {default = "${config.home.homeDirectory}/Downloads/models";};
    model = lib.mkOption {default = "Qwen3.5-9B-Q4_K_M";};
  };
  config = lib.mkIf cfg.enable {
    # home.packages = with pkgs; [pi-coding-agent];
    services.podman = {
      enable = true;
      # https://github.com/ggml-org/llama.cpp/blob/master/docs/docker.md
      containers = {
        "llamacpp" = {
          image = "ghcr.io/ggml-org/llama.cpp:server-rocm";
          autoStart = false;
          volumes = ["${cfg.modelPath}:/models"];
          ports = ["8080:8080"];
          autoUpdate = "registry";
          devices = ["/dev/kfd:/dev/kfd" "/dev/dri:/dev/dri"];
          environment = {
            LLAMA_ARG_MODEL = "/models/${cfg.model}.gguf";
            # LLAMA_ARG_MODELS_DIR = "/models";
            LLAMA_ARG_N_PREDICT = "512";
          };
        };
      };
    };
  };
}
