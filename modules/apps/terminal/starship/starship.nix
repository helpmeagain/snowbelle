{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      programs.starship = {
        enable = lib.mkDefault true;
        settings = builtins.fromTOML (builtins.readFile ./starship.toml);
      };
    };
}
