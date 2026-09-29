{
  flake.modules.homeManager.base =
    { lib, ... }:
    {
      programs.direnv = {
        enable = lib.mkDefault true;
        nix-direnv.enable = true;
        silent = true;
      };
    };
}
