{ pkgs, ... }:

{
  services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Deblot
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa # player de música
    khelpcenter # central de ajuda
    kmahjongg
    kmines
    kpat
    # konsole            # terminal
    # dolphin            # gerenciador de arquivos
    # okular             # visualizador de PDF
  ];
}
