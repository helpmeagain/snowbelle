{ pkgs, ... }:

{
  # STUB — Hyprland + um greeter leve. Falta: portals
  # (xdg-desktop-portal-hyprland), agente de polkit, idle/lock, etc.
  # Preencher quando o host Hyprland existir de verdade.
  programs.hyprland.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
  };
}
