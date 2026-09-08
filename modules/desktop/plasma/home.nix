{ pkgs, ... }:

# https://deepwiki.com/nix-community/plasma-manager/1-overview
{

  home.packages = [
    pkgs.bibata-cursors
  ];

  programs.plasma = {
    enable = true;
    overrideConfig = false;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      theme = "breeze-dark";
      colorScheme = "BreezeDark";
      iconTheme = "breeze-dark";

      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
      };
    };

    session = {
      sessionRestore = {
        restoreOpenApplicationsOnLogin = "startWithEmptySession";
      };
    };
  };

  # programs.konsole = {
  #   enable = true;
  # };
}
