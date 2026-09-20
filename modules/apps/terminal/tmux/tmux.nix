{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      programs.tmux = {
        enable = lib.mkDefault true;
        extraConfig = builtins.readFile ./tmux.conf;
      };
    };
}
