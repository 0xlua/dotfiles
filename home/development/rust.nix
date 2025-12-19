{pkgs, ...}: {
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
}
