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
        shell = lib.getExe pkgs.fish;
        extraConfig = builtins.readFile ./tmux.conf;
      };
    };
}
