{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      verticalTabs = config.dotfiles.firefox.verticalTabs;
    in
    {
      programs.firefox = {
        enable = lib.mkDefault true;
        languagePacks = [
          "pt-BR"
          "en-US"
        ];

        policies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          DisableBuiltinPDFViewer = true;
          PasswordManagerEnabled = false;
          TranslateEnabled = false;

          "DNSOverHTTPS" = {
            "Enabled" = true;
            "ProviderURL" = "https://dns.quad9.net/dns-query";
            "Locked" = true;
            "Fallback" = false;
          };

          SearchEngines = {
            Add = [
              {
                Alias = "@np";
                Description = "Search in NixOS Packages";
                IconURL = "https://nixos.org/favicon.ico";
                Method = "GET";
                Name = "NixOS Packages";
                URLTemplate = "https://search.nixos.org/packages?from=0&size=200&sort=relevance&type=packages&query={searchTerms}";
              }
              {
                Alias = "@no";
                Description = "Search in NixOS Options";
                IconURL = "https://nixos.org/favicon.ico";
                Method = "GET";
                Name = "NixOS Options";
                URLTemplate = "https://search.nixos.org/options?from=0&size=200&sort=relevance&type=packages&query={searchTerms}";
              }
              {
                Alias = "@mn";
                Description = "Search in MyNixOS";
                IconURL = "https://mynixos.com/favicon.ico";
                Method = "GET";
                Name = "MyNixOS Search";
                URLTemplate = "https://mynixos.com/search?q={searchTerms}";
              }
              {
                Alias = "@aw";
                Description = "Search in Arch Wiki";
                IconURL = "https://archlinux.org/favicon.ico";
                Method = "GET";
                Name = "Arch Wiki";
                URLTemplate = "https://wiki.archlinux.org/index.php?search={searchTerms}";
              }
            ];
          };
          ExtensionSettings = {
            # Bloqueia instalação de qualquer extensão não listada abaixo
            "*" = {
              installation_mode = "blocked";
            };
            # uBlock Origin
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "normal_installed";
              private_browsing = true;
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
              private_browsing = true;
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
              private_browsing = true;
            };
            # Firefox Multi-Account Containers
            "@testpilot-containers" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
              installation_mode = "normal_installed";
              private_browsing = true;
            };
            # Dicionário Português (Brasil)
            "pt-BR@dictionaries.addons.mozilla.org" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/corretor/latest.xpi";
              installation_mode = "normal_installed";
              private_browsing = true;
            };
            # Tema Abstract Bold
            "abstract-bold-colorway@mozilla.org" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/abstract-bold_/latest.xpi";
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
            "extensions.activeThemeID" = "abstract-bold-colorway@mozilla.org";

            "sidebar.revamp" = verticalTabs;
            "sidebar.verticalTabs" = verticalTabs;
            "sidebar.main.tools" = "";

            "browser.ai.control.default" = "blocked";
            "browser.ai.control.translations" = "blocked";
            "browser.ai.control.pdfjsAltText" = "blocked";
            "browser.ai.control.smartTabGroups" = "blocked";
            "browser.ai.control.linkPreviewKeyPoints" = "blocked";
            "browser.ai.control.sidebarChatbot" = "blocked";
            "browser.ai.control.smartWindow" = "blocked";
            "extensions.ml.enabled" = false;

            "browser.newtabpage.enabled" = false;
            "browser.startup.page" = 1;
            "browser.startup.homepage" = "about:newtab";

            "spellchecker.dictionary" = "en-US,pt-BR";
            "browser.search.region" = "br";
            "browser.search.isUS" = false;
            "distribution.searchplugins.defaultLocale" = "pt-BR";
            "general.useragent.locale" = "pt-BR";

            # Barra de favoritos sempre visível.
            "browser.toolbars.bookmarks.visibility" = "always";
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
                "nav-bar" = lib.optional verticalTabs "sidebar-button" ++ [
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
                "TabsToolbar" = lib.optionals (!verticalTabs) [
                  "tabbrowser-tabs"
                  "new-tab-button"
                ];
                "vertical-tabs" = lib.optionals verticalTabs [ "tabbrowser-tabs" ];
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

      # Atalhos
      home.file.".config/mozilla/firefox/default/customKeys.json" = {
        force = true;
        text = builtins.toJSON {
          # Expandir/recolher o sidebar
          toggleSidebarKb = {
            modifiers = "control,shift";
            key = "X";
          };
          key_switchTextDirection = { };
        };
      };
    };
}
