{...}: {
  imports = [../../home];
  home-modules.development = {
    enable = true;
    languages = {
      data.enable = true;
    };
  };
}
