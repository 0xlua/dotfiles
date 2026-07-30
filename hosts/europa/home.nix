{lib, ...}: {
  imports = [../../home];
  programs.thunderbird.enable = lib.mkForce false;
  home-modules = {
    desktop = {
      enable = true;
      compositor = "niri";
    };
    mail.enable = true;
    development = {
      enable = true;
      languages = {
        android.enable = true;
        rust.enable = true;
        python.enable = true;
        javascript.enable = true;
        typesetting.enable = true;
        data.enable = true;
      };
    };
  };
}
