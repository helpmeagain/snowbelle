{
  # Only on hyprland
  flake.modules.homeManager.hyprland =
    {
      lib,
      ...
    }:

    {
      programs.kitty.enable = lib.mkDefault true;
    };
}
