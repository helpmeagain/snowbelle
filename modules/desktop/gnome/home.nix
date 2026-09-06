{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib.hm) gvariant;
  mkUint32 = gvariant.mkUint32;
  emptyStrings = gvariant.mkEmptyArray gvariant.type.string;
  mkRaw = value: {
    _type = "gvariant";
    type = "";
    __toString = _: value;
  };

  myExtensions = with pkgs.gnomeExtensions; [
    dash-to-dock
    blur-my-shell
    appindicator
    caffeine
    app-hider
  ];
in

{
  home.packages = myExtensions ++ [
    pkgs.yaru-theme
    pkgs.bibata-cursors
  ];

  # Altera ícone do botão "Mostrar aplicações" para logo do NixOS
  xdg.dataFile."icons/hicolor/scalable/apps/view-app-grid-user-symbolic.svg".source =
    "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
    };
  };

  dconf = {
    enable = true;

    settings = {
      "org/gnome/shell" = {
        # Apps fixados na dock
        favorite-apps = [
          "firefox.desktop"
          "org.gnome.Nautilus.desktop"
          "org.gnome.Console.desktop"
        ];
        disable-user-extensions = false;
        enabled-extensions = map (ext: ext.extensionUuid) myExtensions;
        last-selected-power-profile = "power-saver";
        # Fixa 4 primeiros ícones do menu
        app-picker-layout = mkRaw "[{'System': <{'position': <0>}>, 'Utilities': <{'position': <1>}>, 'org.gnome.Settings.desktop': <{'position': <2>}>, 'org.gnome.Extensions.desktop': <{'position': <3>}>}]";
      };

      "org/gnome/shell/app-switcher" = {
        current-workspace-only = true;
      };

      "org/gnome/shell/keybindings" = {
        switch-to-application-1 = emptyStrings;
        switch-to-application-2 = emptyStrings;
        switch-to-application-3 = emptyStrings;
        switch-to-application-4 = emptyStrings;
        switch-to-application-5 = emptyStrings;
        switch-to-application-6 = emptyStrings;
        switch-to-application-7 = emptyStrings;
        switch-to-application-8 = emptyStrings;
        switch-to-application-9 = emptyStrings;
        toggle-application-view = [ "<Super>space" ];
      };

      "org/gnome/desktop/interface" = {
        monospace-font-name = "JetBrainsMono Nerd Font 11";
        color-scheme = "prefer-dark";
        accent-color = "purple";
        icon-theme = "Yaru-magenta";
        gtk-theme = "Yaru-magenta-dark";
        cursor-theme = "Bibata-Modern-Classic";
        show-battery-percentage = true;
        enable-hot-corners = false;
      };

      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>c" ];
        toggle-maximized = [ "<Super>f" ];
        switch-input-source = emptyStrings;
        switch-input-source-backward = emptyStrings;
        move-to-workspace-1 = [ "<Super><Shift>1" ];
        move-to-workspace-2 = [ "<Super><Shift>2" ];
        move-to-workspace-3 = [ "<Super><Shift>3" ];
        move-to-workspace-4 = [ "<Super><Shift>4" ];
        move-to-workspace-5 = [ "<Super><Shift>5" ];
        move-to-workspace-6 = [ "<Super><Shift>6" ];
        move-to-workspace-7 = [ "<Super><Shift>7" ];
        move-to-workspace-8 = [ "<Super><Shift>8" ];
        switch-to-workspace-1 = [ "<Super>1" ];
        switch-to-workspace-2 = [ "<Super>2" ];
        switch-to-workspace-3 = [ "<Super>3" ];
        switch-to-workspace-4 = [ "<Super>4" ];
        switch-to-workspace-5 = [ "<Super>5" ];
        switch-to-workspace-6 = [ "<Super>6" ];
        switch-to-workspace-7 = [ "<Super>7" ];
        switch-to-workspace-8 = [ "<Super>8" ];
      };

      "org/gnome/desktop/wm/preferences" = {
        action-double-click-titlebar = "toggle-maximize";
        action-middle-click-titlebar = "lower";
        button-layout = ":minimize,close";
        num-workspaces = 5;
        resize-with-right-button = true;
      };

      "org/gnome/mutter" = {
        center-new-windows = true;
        dynamic-workspaces = false;
        edge-tiling = true;
        experimental-features = [ "scale-monitor-framebuffer" ];
        workspaces-only-on-primary = true;
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        ];
        www = [ "<Super>b" ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Suspender";
        binding = "<Shift><Super>l";
        command = "systemctl suspend";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "Terminal";
        binding = "<Super>t";
        command = "kgx";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
        name = "Nautilius";
        binding = "<Super>e";
        command = "nautilus --new-window";
      };

      "org/gnome/desktop/session" = {
        idle-delay = mkUint32 300;
      };

      "org/gnome/settings-daemon/plugins/power" = {
        idle-dim = true;
        sleep-inactive-ac-timeout = 3600;
        sleep-inactive-ac-type = "nothing";
      };

      "org/gnome/desktop/privacy" = {
        old-files-age = mkUint32 30;
        recent-files-max-age = -1;
      };

      "org/gnome/desktop/media-handling" = {
        automount = false;
        automount-open = false;
      };

      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "list-view";
        search-filter-time-type = "last_modified";
        show-create-link = true;
        show-delete-permanently = true;
        show-image-thumbnails = "always";
      };
      "org/gnome/nautilus/icon-view" = {
        default-zoom-level = "medium";
      };

      "org/gnome/shell/extensions/dash-to-dock" = {
        always-center-icons = true;
        animation-time = 0.1;
        background-opacity = 0.9;
        custom-theme-shrink = false;
        dash-max-icon-size = 54;
        disable-overview-on-startup = true;
        dock-fixed = false;
        dock-position = "BOTTOM";
        extend-height = false;
        height-fraction = 0.9;
        hide-delay = 0.05;
        hot-keys = false;
        hotkeys-overlay = true;
        hotkeys-show-dock = true;
        icon-size-fixed = false;
        intellihide-mode = "ALL_WINDOWS";
        isolate-monitors = true;
        isolate-workspaces = true;
        multi-monitor = true;
        preferred-monitor = -2;
        preferred-monitor-by-connector = "eDP-1";
        pressure-threshold = 65.0;
        preview-size-scale = 0.0;
        running-indicator-style = "DOTS";
        shortcut = [ "<Super>q" ];
        shortcut-text = "<Super>q";
        shortcut-timeout = 2.0;
        show-mounts = false;
        show-mounts-only-mounted = false;
        show-trash = true;
        transparency-mode = "DEFAULT";
      };

      "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
        blur = true;
        brightness = 0.3;
        sigma = 30;
      };
      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        blur = true;
        pipeline = "pipeline_default";
        static-blur = true;
      };
      "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
        blur = true;
        brightness = 0.50;
        corner-radius = 25;
        pipeline = "pipeline_default";
        sigma = 10;
        static-blur = false;
        style-dash-to-dock = 0;
        unblur-in-overview = false;
      };
      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        brightness = 0.45;
        corner-radius = 0;
        force-light-text = false;
        pipeline = "pipeline_default";
        sigma = 25;
        static-blur = false;
        unblur-in-overview = true;
      };
      "org/gnome/shell/extensions/blur-my-shell/window-list" = {
        blur = true;
        brightness = 0.6;
        sigma = 30;
      };

      "org/gnome/shell/extensions/caffeine" = {
        cli-toggle = false;
        countdown-timer = 0;
        duration-timer = 2;
        duration-timer-list = [
          900
          1800
          3600
        ];
        indicator-position-max = 1;
        show-timer = false;
        user-enabled = false;
      };

      "org/gnome/shell/extensions/appindicator" = {
        icon-brightness = 0.0;
        icon-contrast = 0.0;
        icon-opacity = 240;
        icon-saturation = 0.0;
        icon-size = 0;
      };

      "org/gnome/shell/extensions/app-hider" = {
        hidden-apps = [
          "qt6ct.desktop"
          "qt5ct.desktop"
          "remote-viewer.desktop"
          "org.gnome.seahorse.Application.desktop"
          "gnome-session-properties.desktop"
          "software-properties-gtk.desktop"
          "org.gnome.font-viewer.desktop"
          "yelp.desktop"
          "info.desktop"
          "kitty-directory.desktop"
          "libreoffice-base.desktop"
          "libreoffice-calc.desktop"
          "libreoffice-draw.desktop"
          "libreoffice-impress.desktop"
          "libreoffice-math.desktop"
          "libreoffice-writer.desktop"
        ];
      };
    };
  };
}
