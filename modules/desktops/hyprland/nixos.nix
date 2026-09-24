{
  flake.modules.nixos.hyprland =
    { pkgs, ... }:

    {
      programs.hyprland = {
        enable = true;
        package = pkgs.unstable.hyprland;
        portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
      };

      services.upower.enable = true;
      services.power-profiles-daemon.enable = true;

      qt = {
        enable = true;
        platformTheme = "kde";
        style = "breeze";
      };

      services.greetd = {
        enable = true;
        settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd start-hyprland";
      };
    };
}
