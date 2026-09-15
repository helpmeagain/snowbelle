{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.git = {
        enable = lib.mkDefault true;
        settings = {
          user = {
            name = lib.mkDefault "helpmeagain";
            email = lib.mkDefault "57302703+helpmeagain@users.noreply.github.com";
          };
          init.defaultBranch = lib.mkDefault "main";
          pull.rebase = lib.mkDefault false;
        };
      };
    };
}
