{
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = true;
        addKeysToAgent = "yes";
        serverAliveInterval = 60;
      };
      desy = {
        hostname = "bastion.desy.de";
        user = "jordanlu";
        dynamicForwards = [{port = 2280;}];
      };
      galileo = {
        hostname = "lua.one";
      };
      backup = {
        hostname = "u413359.your-storagebox.de";
        user = "u413359";
        port = 23;
      };
      baucons = {
        hostname = "49.12.185.229";
        user = "root";
      };
    };
  };
}
