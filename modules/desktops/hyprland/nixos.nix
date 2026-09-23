{
  flake.modules.nixos.hyprland =
    { pkgs, ... }:

    {
      programs.hyprland = {
        enable = true;
        package = pkgs.unstable.hyprland;
        portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
      };

      services.greetd = {
        enable = true;
        # start-hyprland (script que já vem com o pacote a partir da 0.53) é
        # quem hoje monta as env vars certas (portals, XDG, screen share) —
        # o uwsm foi rebaixado a "experimental / usuário avançado" no upstream.
        settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd start-hyprland";
      };
    };
}
