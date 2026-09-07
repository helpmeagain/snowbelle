{ pkgs, ... }:

let
  # Lib `Blur.BlurEffect` com corner radius, usada pelo blur-my-shell para
  # corrigir os cantos arredondados sob blur dinâmico.
  gnome-rounded-blur = pkgs.callPackage ../../pkgs/gnome-rounded-blur.nix { };
in
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    # gnome-bluetooth      # applet de bluetooth (não remova se usar bluetooth pela GUI)
    # gnome-color-manager  # calibração de cor de monitor

    # baobab               # analisador de uso de disco
    decibels # player de audiobooks
    epiphany # navegador GNOME Web
    # gnome-text-editor    # editor de texto (Gedit novo)
    # gnome-calculator
    # gnome-calendar
    # gnome-characters     # mapa de caracteres/emojis
    # gnome-clocks
    # gnome-console        # kgx (você já usa via atalho <Super>t)
    gnome-contacts
    gnome-font-viewer
    # gnome-logs           # visualizador de logs (journalctl com GUI)
    gnome-maps
    gnome-music
    # gnome-system-monitor
    # gnome-tecla          # mostra teclas pressionadas (debug de teclado)
    gnome-weather
    # loupe                # visualizador de imagens
    # nautilus             # gerenciador de arquivos (você usa via <Super>e, não remova)
    # papers               # visualizador de PDF (antigo Evince)
    gnome-connections # cliente RDP/VNC
    # showtime             # player de vídeo
    simple-scan # digitalização
    snapshot # câmera/webcam
    yelp # visualizador de ajuda
  ];

  # A extensão blur-my-shell importa `gi://Blur` de dentro do gnome-shell. O
  # wrapper do gnome-shell usa `--prefix` nessa variável, ou seja, preserva o que
  # vier do ambiente — e o PAM a define antes da sessão gráfica subir.
  environment.sessionVariables.GI_TYPELIB_PATH = "${gnome-rounded-blur}/lib/girepository-1.0";
}
