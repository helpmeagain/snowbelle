{
  # Only on gnome
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

  flake.modules.nixos.gnome = {
    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "ptyxis";
    };
  };
}
