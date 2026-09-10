{
  config,
  lib,
  pkgs,
  hostIsNixos,
  userSettings,
  ...
}:

let
  wallpaper = "${config.home.homeDirectory}/${userSettings.wallpaper}";

  # Estilo dos painéis, escolhido em flake.nix (userSettings.plasmaPanelStyle):
  #   "gnomeLike"   -> barra fina no topo + dock flutuante embaixo
  #   "windowsLike" -> barra única embaixo (iniciar + tarefas + bandeja + relógio)
  panelStyle = userSettings.plasmaPanelStyle or "gnomeLike";
  windowsLike = panelStyle == "windowsLike";

  # --- Widgets compartilhados pelos dois estilos ---
  kickoffWidget = {
    kickoff = {
      icon = if hostIsNixos then "nix-snowflake-white" else null;
      showActionButtonCaptions = false;
      settings.General.highlightNewlyInstalledApps = false;
    };
  };

  iconTasksWidget = {
    iconTasks = {
      launchers = [
        "preferred://browser"
        "preferred://filemanager"
        "applications:org.kde.konsole.desktop"
      ];
    };
  };

  digitalClockWidget = {
    digitalClock = {
      # No windows-like só a hora aparece (sem data ao lado); no gnome-like
      # a data continua no formato custom, ao lado da hora.
      date = {
        enable = !windowsLike;
        format.custom = "ddd d |";
        position = "besideTime";
      };
      font = {
        family = "JetBrainsMono Nerd Font Mono";
        size = 14;
        weight = 400;
        style = "Regular";
      };
    };
  };

  systemTrayWidget = {
    systemTray = {
      icons.scaleToFit = true;
      items = {
        extra = [
          "org.kde.plasma.vault"
          "org.kde.plasma.cameraindicator"
          "org.kde.plasma.devicenotifier"
          "org.kde.plasma.manage-inputmethod"
          "org.kde.plasma.notifications"
          "org.kde.plasma.keyboardlayout"
          "org.kde.plasma.printmanager"
          "org.kde.plasma.keyboardindicator"
          "org.kde.plasma.weather"
          "org.kde.kscreen"
          "org.kde.plasma.clipboard"
          "org.kde.plasma.brightness"
          "org.kde.plasma.networkmanagement"
          "org.kde.plasma.bluetooth"
          "org.kde.plasma.volume"
          "org.kde.plasma.mediacontroller"
          "org.kde.plasma.battery"
          "org.kde.kdeconnect"
        ];
        hidden = [
          "org.kde.plasma.clipboard"
          "org.kde.plasma.brightness"
          "org.kde.plasma.networkmanagement"
          "org.kde.plasma.bluetooth"
          "org.kde.plasma.volume"
          "org.kde.plasma.mediacontroller"
          "org.kde.plasma.battery"
          "Notificador do Discover_org.kde.DiscoverNotifier"
          "Bitwarden_status_icon_1"
        ];
      };
    };
  };

  # --- Layouts de painel ---
  panelsByStyle = {
    # Barra de status no topo (relógio central, bandeja à direita) e dock
    # flutuante embaixo, só com os lançadores/janelas.
    gnomeLike = [
      {
        location = "top";
        height = 25;
        floating = false;
        opacity = "opaque";
        screen = "all";
        widgets = [
          kickoffWidget
          {
            pager = {
              general = {
                displayedText = "desktopNumber";
                showOnlyCurrentScreen = true;
                showWindowOutlines = false;
              };
            };
          }
          "org.kde.plasma.panelspacer"
          digitalClockWidget
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.marginsseparator"
          systemTrayWidget
          "org.kde.plasma.networkmanagement"
          "org.kde.plasma.bluetooth"
          "org.kde.plasma.volume"
          { battery.showPercentage = true; }
        ];
      }

      {
        location = "bottom";
        height = 55;
        floating = true;
        lengthMode = "fit";
        hiding = "dodgewindows";
        opacity = "translucent";
        screen = "all";
        widgets = [ iconTasksWidget ];
      }
    ];

    # Barra única embaixo: menu iniciar à esquerda, barra de tarefas, e
    # bandeja + relógio à direita.
    windowsLike = [
      {
        location = "bottom";
        height = 44;
        floating = false;
        opacity = "opaque";
        screen = "all";
        widgets = [
          kickoffWidget
          iconTasksWidget
          "org.kde.plasma.marginsseparator"
          systemTrayWidget
          "org.kde.plasma.networkmanagement"
          "org.kde.plasma.bluetooth"
          "org.kde.plasma.volume"
          { battery.showPercentage = true; }
          digitalClockWidget
        ];
      }
    ];
  };

  panels =
    panelsByStyle.${panelStyle}
      or (throw "userSettings.plasmaPanelStyle inválido: \"${panelStyle}\" (use \"gnomeLike\" ou \"windowsLike\")");

  vscodeBin = if userSettings.vscodePkg == "vscode" then "code" else "codium";
  vscodeIcon = if userSettings.vscodePkg == "vscode" then "vscode" else "vscodium";
in
{

  home.packages = with pkgs; [
    bibata-cursors
    kdePackages.krohnkite
  ];

  programs.firefox.nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];

  xdg.dataFile."color-schemes/BreezeDarkCustom.colors".source =
    ./color-schemes/BreezeDarkCustom.colors;

  xdg.dataFile."kio/servicemenus/open-with-vscode.desktop".text = ''
    [Desktop Entry]
    Type=Service
    X-KDE-ServiceTypes=KonqPopupMenu/Plugin
    MimeType=all/allfiles;inode/directory;
    Actions=openWithVSCode;
    X-KDE-Priority=TopLevel

    [Desktop Action openWithVSCode]
    Name=Abrir com VSCode
    Icon=${vscodeIcon}
    Exec=${vscodeBin} %U
  '';

  programs.plasma = {
    enable = true;
    overrideConfig = false;

    # === Aparência ===
    workspace = {
      theme = "breeze-dark";
      colorScheme = "BreezeDarkCustom";
      iconTheme = "breeze-dark";

      inherit wallpaper;
      wallpaperFillMode = "preserveAspectCrop";

      windowDecorations = {
        library = "org.kde.breeze";
        theme = "Breeze";
      };

      splashScreen = {
        engine = "none";
        theme = "None";
      };

      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
      };
    };

    # === Tela de bloqueio ===
    kscreenlocker.appearance.wallpaper = wallpaper;

    fonts = {
      general = {
        family = "Noto Sans";
        pointSize = 10;
      };
      fixedWidth = {
        family = "Noto Sans Mono";
        pointSize = 10;
      };
      small = {
        family = "Noto Sans";
        pointSize = 8;
      };
      toolbar = {
        family = "Noto Sans";
        pointSize = 9;
      };
      menu = {
        family = "Noto Sans";
        pointSize = 10;
      };
    };

    # === KWin ===
    kwin = {
      virtualDesktops = {
        number = 5;
        rows = 1;
      };

      tiling.padding = 4;

      effects = {
        blur = {
          enable = true;
          strength = 4;
          noiseStrength = 2;
        };
        dimInactive.enable = true;
        shakeCursor.enable = false;
        desktopSwitching.animation = "fade";
      };
    };

    krunner = {
      position = "center";
      shortcuts.launch = "Meta+Space";
    };

    # === Sessão ===
    session = {
      sessionRestore = {
        restoreOpenApplicationsOnLogin = "startWithEmptySession";
      };
    };

    # === Painéis ===
    inherit panels;

    # === Atalhos ===
    shortcuts = {
      kwin = {
        "Overview" = if windowsLike then "Meta+W" else "Meta";
        "Edit Tiles" = "Meta+Shift+T";
        "Window Close" = [
          "Alt+F4"
          "Meta+C"
        ];
        "Window Fullscreen" = "Meta+Shift+F";
        "Window Maximize" = [
          "Meta+F"
          "Meta+PgUp"
        ];

        "Switch to Desktop 1" = [
          "Ctrl+F1"
          "Meta+1"
        ];
        "Switch to Desktop 2" = [
          "Ctrl+F2"
          "Meta+2"
        ];
        "Switch to Desktop 3" = [
          "Ctrl+F3"
          "Meta+3"
        ];
        "Switch to Desktop 4" = [
          "Ctrl+F4"
          "Meta+4"
        ];
        "Switch to Desktop 5" = "Meta+5";

        "Window to Desktop 1" = "Meta+!";
        "Window to Desktop 2" = "Meta+@";
        "Window to Desktop 3" = "Meta+#";
        "Window to Desktop 4" = "Meta+$";
        "Window to Desktop 5" = "Meta+%";

        # Krohnkite (tiling)
        "KrohnkiteFocusLeft" = "Meta+H";
        "KrohnkiteFocusDown" = "Meta+J";
        "KrohnkiteFocusUp" = "Meta+K";
        "KrohnkiteShiftLeft" = "Meta+Shift+H";
        "KrohnkiteShiftDown" = "Meta+Shift+J";
        "KrohnkiteShiftUp" = "Meta+Shift+K";
        "KrohnkiteShrinkWidth" = "Meta+Ctrl+H";
        "KrohnkitegrowWidth" = "Meta+Ctrl+L";
        "KrohnkiteGrowHeight" = "Meta+Ctrl+J";
        "KrohnkiteShrinkHeight" = "Meta+Ctrl+K";
        "KrohnkiteMonocleLayout" = "Meta+M";
        "KrohnkiteFocusPrev" = "Meta+,";
        "KrohnkiteNextLayout" = "Meta+\\";
        "KrohnkitePreviousLayout" = "Meta+|";
      };

      ksmserver = {
        "Log Out" = [
          "Ctrl+Alt+Del"
          "Meta+Backspace"
        ];
      };

      org_kde_powerdevil = {
        "Sleep" = [
          "Sleep"
          "Meta+Shift+L"
        ];
        "powerProfile" = [
          "Battery"
          "Meta+B"
        ];
      };

      plasmashell = {
        "activate application launcher" =
          if windowsLike then
            [
              "Alt+F1"
              "Meta"
            ]
          else
            "Alt+F1";
        "next activity" = "Meta+A";
        "previous activity" = "Meta+Shift+A";

        "activate task manager entry 1" = "none";
        "activate task manager entry 2" = "none";
        "activate task manager entry 3" = "none";
        "activate task manager entry 4" = "none";
        "activate task manager entry 5" = "none";
        "activate task manager entry 6" = "none";
        "activate task manager entry 7" = "none";
        "activate task manager entry 8" = "none";
        "activate task manager entry 9" = "none";
      };

      "services/org.kde.konsole.desktop" = {
        _launch = [
          "Meta+T"
          "Meta+Return"
        ];
      };

      "services/org.kde.plasma-systemmonitor.desktop" = {
        _launch = [
          "Ctrl+Shift+Esc"
          "Meta+Esc"
        ];
      };
    };

    # === etc ===
    configFile = {
      kwinrc = {
        "Effect-blur".Saturation = 246;
        "Effect-diminactive".Strength = 10;
        "Effect-mousemark".Color = "255,128,255";
        "Effect-overview".BorderActivate = 9;

        Plugins = {
          mousemarkEnabled = true;
          translucencyEnabled = true;
          krohnkiteEnabled = true;
          gamecontrollerEnabled = false;
        };

        "Script-krohnkite" = {
          screenGapTop = 5;
          screenGapBottom = 5;
          screenGapLeft = 5;
          screenGapRight = 5;
          screenGapBetween = 5;

          floatingLayoutOrder = 1;
          spiralLayoutOrder = 2;

          tileLayoutOrder = 0;
          monocleLayoutOrder = 0;
          binaryTreeLayoutOrder = 0;
          cascadeLayoutOrder = 0;
          columnsLayoutOrder = 0;
          quarterLayoutOrder = 0;
          spreadLayoutOrder = 0;
          stackedLayoutOrder = 0;
          stairLayoutOrder = 0;
          threeColumnLayoutOrder = 0;
        };

        TabBox.SwitchingMode = 1;
        Wayland.VirtualKeyboardMode = 2;
        Windows.PerOutputVirtualDesktops = true;

        # Específico do notebook (tela HiDPI)
        Xwayland = {
          Scale = 1.2;
          XwaylandEisNoPromptApps = "steam";
        };
      };

      kdeglobals = {
        General = {
          AccentColor = "49,114,179";
          accentColorFromWallpaper = true;
          UseSystemBell = true;
          XftAntialias = true;
          XftHintStyle = "hintslight";
          XftSubPixel = "rgb";
        };
        KDE = {
          AnimationDurationFactor = 0.25;
          ShowDeleteCommand = false;
          contrast = 4;
          frameContrast = 0.2;
        };
        "KFileDialog Settings" = {
          "Show hidden files" = true;
          "Sort by" = "Date";
          "View Style" = "DetailTree";
          "Show Speedbar" = true;
          "Show Inline Previews" = true;
          "Breadcrumb Navigation" = false;
        };
        PreviewSettings = {
          EnableRemoteFolderThumbnail = false;
          MaximumRemoteSize = 0;
        };
      };

      krunnerrc = {
        Plugins = {
          krunner_dictionaryEnabled = false;
          krunner_sessionsEnabled = false;
        };
        "Plugins/Favorites".plugins =
          "windows,krunner_services,krunner_powerdevil,krunner_systemsettings,krunner_sessions";
        "Runners/krunner_dictionary".triggerWord = "definir";
        "Runners/krunner_kill" = {
          sorting = 1;
          triggerWord = "end";
          useTriggerWord = true;
        };
        "Runners/krunner_spellcheck" = {
          requireTriggerWord = true;
          trigger = "orto";
        };
      };

      klipperrc.General = {
        IgnoreImages = false;
        KeepClipboardContents = false;
      };

      plasma-localerc.Formats.LANG = "pt_BR.UTF-8";

      dolphinrc = {
        General = {
          ConfirmClosingMultipleTabs = false;
          RememberOpenedTabs = false;
        };
        MainWindow.MenuBar = "Disabled";
        IconsMode.PreviewSize = 96;
        "Notification Messages".warnAboutRisksBeforeActingAsAdmin = false;
      };

      # katerc = {
      #   General = {
      #     "Show Menu Bar" = true;
      #     "Show Status Bar" = true;
      #     "Show Tab Bar" = true;
      #     "Show Url Nav Bar" = true;
      #   };
      #   "KTextEditor Renderer" = {
      #     "Auto Color Theme Selection" = true;
      #     "Color Theme" = "Breeze Dark";
      #     "Animate Bracket Matching" = false;
      #     "Show Indentation Lines" = false;
      #   };
      # };

      systemsettingsrc."KFileDialog Settings".detailViewIconSize = 32;
      xdg-desktop-portal-kderc."KFileDialog Settings".detailViewIconSize = 48;
    };
  };

  # === Aplicar wallpaper/painéis sem sair da sessão ===
  #
  # Fix by Claude
  #
  # Os desktop-scripts do plasma-manager (o que aplica `workspace.wallpaper`,
  # `panels`, etc.) só rodam via `qdbus … evaluateScript`, disparado pelo
  # autostart do KDE (`X-KDE-autostart-condition=ksmserver`). Isso significa
  # que um `hupdate` (home-manager switch) sozinho NÃO os aplica -- só o
  # próximo login roda o run_all.sh que os executa.
  #
  # Rodamos o run_all.sh nós mesmos logo depois do "linkGeneration" (etapa em
  # que os arquivos do generation novo, incluindo o próprio run_all.sh, são
  # symlinkados pro $HOME -- antes disso ele ainda não existe). Assim
  # `hupdate` já aplica o wallpaper e o resto na hora, sem precisar deslogar.
  #
  # É seguro rodar em toda ativação: os scripts só reexecutam o que mudou de
  # conteúdo (comparação por sha256) e erros individuais (ex.: plasmashell
  # ainda não estar rodando) ficam contidos dentro do próprio run_all.sh, sem
  # derrubar a ativação do home-manager.
  #
  # O `PATH` dentro do activation-script do home-manager é fixo (só as
  # ferramentas que ele mesmo usa) e não inclui `qdbus`, os `plasma-apply-*`
  # nem `systemctl`, mesmo eles estando disponíveis no shell interativo via
  # /run/current-system/sw/bin. Sem `qdbus` os desktop-scripts falham
  # silenciosamente com "comando não encontrado" -- e como o script de
  # painéis primeiro APAGA o plasma-org.kde.plasma.desktop-appletsrc antes de
  # tentar recriá-lo via qdbus, uma falha aqui deixa esse arquivo ausente até
  # o próximo login. Sem os `plasma-apply-*`, o script de temas não aplica
  # tema/cursor/esquema de cores. Sem `systemctl`, o restart do plasmashell
  # no final do run_all.sh (disparado sempre que os painéis usam
  # `screen` != null) também falha.
  #
  # Cada desktop-script guarda o sha256 do .js que aplicou por último em
  # `last_run_<script>`, e só reexecuta quando esse hash muda. Isso quer dizer
  # que mudanças feitas na mão pela GUI do Plasma (arrastar um painel, trocar
  # widgets) NÃO são desfeitas no `hupdate` seguinte: pro plasma-manager o
  # ".js desejado" continua igual ao que ele já aplicou, então ele pula. Para
  # forçar a reaplicação (redesenhar os painéis a partir do zero), apague os
  # marcadores antes: `PLASMA_FORCE_APPLY=1 hupdate`.
  home.activation.plasmaManagerRunNow = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    if [ -n "''${PLASMA_FORCE_APPLY:-}" ]; then
      run rm -f ${config.xdg.dataHome}/plasma-manager/last_run_*
    fi
    PATH="${pkgs.kdePackages.qttools}/bin:${pkgs.kdePackages.plasma-workspace}/bin:${pkgs.systemd}/bin:$PATH" run ${config.xdg.dataHome}/plasma-manager/run_all.sh
  '';

  # === Konsole ===
  programs.konsole = {
    enable = true;
    defaultProfile = "Perfil 1";

    profiles."Perfil 1" = {
      name = "Perfil 1";
      colorScheme = "DarkPastels";
      font = {
        name = "JetBrains Mono";
        size = 13;
      };
      extraConfig = {
        Appearance.WordMode = "false";
      };
    };

    extraConfig = {
      MainWindow.MenuBar = "Disabled";
      KonsoleWindow.ShowWindowTitleOnTitleBar = "true";
      "Notification Messages".CloseAllTabs = "true";
    };
  };
}
