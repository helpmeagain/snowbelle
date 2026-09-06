{ config, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    languagePacks = [
      "pt-BR"
      "en-US"
    ];

    policies = {
      ExtensionSettings = {
        # Bloqueia instalação de qualquer extensão não listada abaixo
        "*" = {
          installation_mode = "blocked";
        };
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "normal_installed";
        };
        # KeePassXC-Browser
        "keepassxc-browser@keepassxc.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
          installation_mode = "normal_installed";
        };
        # Plasma Browser Integration
        "plasma-browser-integration@kde.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/plasma-integration/latest.xpi";
          installation_mode = "normal_installed";
        };
        # Bitwarden Password Manager
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "normal_installed";
        };
        # Video DownloadHelper
        "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/video-downloadhelper/latest.xpi";
          installation_mode = "normal_installed";
        };
        # Firefox Multi-Account Containers
        "@testpilot-containers" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
    };

    profiles.default = {
      id = 0;
      isDefault = true;

      search = {
        force = true;
        default = "ddg";
      };

      settings = {
        "browser.uiCustomization.state" = builtins.toJSON {
          placements = {
            "widget-overflow-fixed-list" = [ ];
            "unified-extensions-area" = [
              "_testpilot-containers-browser-action"
              "ublock0_raymondhill_net-browser-action"
              "_b9db16a4-6edc-47ec-a1f4-b86292ed211d_-browser-action"
              "plasma-browser-integration_kde_org-browser-action"
              "1094918_gmail_com-browser-action"
              "keepassxc-browser_keepassxc_org-browser-action"
              "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
            ];
            "nav-bar" = [
              "sidebar-button"
              "back-button"
              "forward-button"
              "vertical-spacer"
              "stop-reload-button"
              "urlbar-container"
              "reset-pbm-toolbar-button"
              "downloads-button"
              "unified-extensions-button"
            ];
            "toolbar-menubar" = [ "menubar-items" ];
            "TabsToolbar" = [
              "tabbrowser-tabs"
              "new-tab-button"
            ];
            "vertical-tabs" = [ ];
            "PersonalToolbar" = [ "personal-bookmarks" ];
          };
          seen = [
            "reset-pbm-toolbar-button"
            "developer-button"
            "screenshot-button"
            "_b9db16a4-6edc-47ec-a1f4-b86292ed211d_-browser-action"
            "plasma-browser-integration_kde_org-browser-action"
            "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
            "_testpilot-containers-browser-action"
            "1094918_gmail_com-browser-action"
            "ublock0_raymondhill_net-browser-action"
            "keepassxc-browser_keepassxc_org-browser-action"
          ];
          dirtyAreaCache = [
            "nav-bar"
            "vertical-tabs"
            "PersonalToolbar"
            "unified-extensions-area"
            "toolbar-menubar"
            "TabsToolbar"
          ];
          currentVersion = 25;
          newElementCount = 5;
        };
      };
    };
  };
}
