{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops.secrets."rustypasteToken".mode = "0440";

  home.packages = with pkgs; [rustypaste-cli];

  xdg.configFile."rustypaste/config.toml".source = (pkgs.formats.toml {}).generate "rustypaste-cli-config" {
    server = {
      address = "https://share.lua.one";
      auth_token_file = "${config.sops.secrets."rustypasteToken".path}";
    };
    paste.oneshot = false;
    style.prettify = false;
  };
}
