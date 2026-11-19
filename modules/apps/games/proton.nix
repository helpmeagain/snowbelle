{
  flake.modules.homeManager.base = { pkgs, ... }: {
    dotfiles.packages = [ pkgs.protonup-qt ];
  };
}
