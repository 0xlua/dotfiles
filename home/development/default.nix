{pkgs, ...}: {
  imports = [
    ./javascript.nix
    ./python.nix
    ./rust.nix
    ./writing.nix
    ./data.nix
  ];
  home.packages = with pkgs; [
    nil
    mago

    # Formatter
    alejandra
    stylua

    # CLI Tools
    hurl # HTTP Requests from files
    just # command runner
    grex # regex generator
    gitu # magit-like git interface

    # Misc
    sops # nix secrets
    zola # static site renderer
  ];

  programs.git-cliff.enable = true;

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.gh-dash.enable = true;

  programs.jujutsu = {
    enable = true;
  };
}
