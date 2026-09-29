{ inputs, ... }:

{
  flake.modules.homeManager.hyprland = {
    imports = [ inputs.noctalia.homeModules.default ];

    programs.noctalia = {
      enable = true;
      systemd.enable = false;
      settings = ./noctalia.toml;
    };
  };
}
