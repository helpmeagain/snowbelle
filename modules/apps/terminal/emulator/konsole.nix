{
  # Only on plasma
  flake.modules.homeManager.plasma =
    {
      lib,
      pkgs,
      ...
    }:

    {
      programs.konsole = {
        enable = true;
        defaultProfile = "Perfil 1";

        customColorSchemes.DarkPastels = ../../desktops/plasma/color-schemes/DarkPastels.colorscheme;

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
    };
}
