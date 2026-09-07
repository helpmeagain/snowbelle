{ pkgs, ... }:

{
  # STUB — habilita o mínimo do Plasma 6. Falta: theming, excludePackages
  # equivalente ao do GNOME, autologin, etc. Preencher quando o host KDE
  # existir de verdade.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
}
