{
  flake.modules.homeManager.base = { pkgs, ... }: {
    dotfiles.packages = [ pkgs.discord ];
  };
}
