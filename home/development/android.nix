{pkgs, ...}: {
  home.packages = with pkgs; [
    scrcpy # mirror android screen
  ];
}
