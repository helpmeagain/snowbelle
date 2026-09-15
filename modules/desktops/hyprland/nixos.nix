{
  flake.modules.nixos.hyprland =
    { pkgs, ... }:

    {
      programs.hyprland.enable = true;

      services.greetd = {
        enable = true;
        settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      };
    };
}
