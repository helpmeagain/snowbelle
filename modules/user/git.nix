{ config, pkgs, ... }: 
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "helpmeagain";
        email = "57302703+helpmeagain@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}