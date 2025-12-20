{pkgs, ...}: {
  home.packages = with pkgs; [
    deno #js runtime
    zola # static site renderer
    biome # js lsp
    superhtml # html lsp
  ];
}
