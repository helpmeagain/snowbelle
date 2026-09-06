{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot = {
    loader = {
      systemd-boot.enable = false;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
      efi.canTouchEfiVariables = true;
    };

    initrd.systemd.enable = true;

    plymouth.enable = true;
    kernelParams = [ "quiet" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # services.system-config-printer.enable = false; # App do DE para configurar a impressora

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # Use the WirePlumber session manager
    #wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."help" = {
    isNormalUser = true;
    description = "help";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # Allow dynamically linked "generic Linux" binaries to run (e.g. VS Code
  # extensions that ship prebuilt native binaries, like Claude Code).
  # See: https://nix.dev/permalink/stub-ld
  programs.nix-ld.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  documentation.nixos.enable = false;

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  environment.systemPackages = with pkgs; [
    #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false; # Disable the firewall altogether.

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
