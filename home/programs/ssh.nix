{
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = true;
        AddKeysToAgent = "yes";
        ServerAliveInterval = 60;
      };
      desy = {
        HostName = "bastion.desy.de";
        User = "jordanlu";
        DynamicForward = 2280;
      };
      galileo = {
        HostName = "lua.one";
      };
      backup = {
        HostName = "u413359.your-storagebox.de";
        User = "u413359";
        Port = 23;
      };
      baucons = {
        HostName = "49.12.185.229";
        User = "root";
      };
    };
  };
}
