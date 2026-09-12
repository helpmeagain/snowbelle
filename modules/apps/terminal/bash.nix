{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      programs.bash = {
        enable = lib.mkDefault true;
      };
    };
}
