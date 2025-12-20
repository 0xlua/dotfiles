{pkgs, ...}: {
  home.packages = with pkgs; [
    mago # php lsp
    stylua # lua formatter
    hurl # HTTP Requests from files
    just # command runner
    grex # regex generator
  ];
}
