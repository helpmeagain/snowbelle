{ inputs, ... }:

{
  flake.modules.homeManager.hyprland =
    {
      imports = [ inputs.noctalia.homeModules.default ];

      wayland.windowManager.hyprland.enable = true;

      # Config básica — o resto (bar, widgets, tema) fica pra depois.
      # O package já vem definido (mkDefault) pelo próprio homeModules.default do noctalia.
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
      };
    };
}
