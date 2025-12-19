{pkgs, ...}: {
  home.packages = with pkgs; [
    deno

    # LSP
    biome
    superhtml
  ];
}
