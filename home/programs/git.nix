{pkgs, ...}: {
  home.packages = with pkgs; [
    gitu # magit-like git interface
  ];
  programs.mergiraf.enable = true;

  programs.difftastic = {
    enable = true;
    git.enable = true;
    git.diffToolMode = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "0xlua";
        email = "dev@lukasjordan.com";
      };
      help.autocorrect = "prompt";
      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      init.defaultBranch = "main";
      push = {
        autoSetupRemote = true;
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      pull.rebase = true;
    };
  };

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
