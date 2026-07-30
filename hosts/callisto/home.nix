{...}: {
  imports = [../../home];
  home-modules = {
    desktop = {
      enable = true;
      compositor = "cosmic";
    };
    mail.enable = true;
    gaming.enable = true;
    llm.enable = true;
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
