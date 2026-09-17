{
  flake.modules.homeManager.gnome =
    {
      lib,
      pkgs,
      ...
    }:

    {
      programs.ptyxis = {
        enable = lib.mkDefault true;
        package = pkgs.ptyxis;
      };
    };
}
