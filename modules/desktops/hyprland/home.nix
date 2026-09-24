{
  flake.modules.homeManager.hyprland =
    { lib, pkgs, ... }:

    {
      xdg.configFile."hypr" = {
        source = ./conf;
        recursive = true;
      };

      home.packages = with pkgs; [
        kdePackages.dolphin
        kdePackages.breeze-icons
        bibata-cursors
        adw-gtk3
      ];

      dconf.settings."org/gnome/desktop/interface".icon-theme = "breeze-dark";
      home.activation.kdeIconTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kdeglobals --group Icons --key Theme breeze-dark
      '';

      xdg.dataFile =
        lib.genAttrs
          [
            "applications/systemsettings.desktop"
            "applications/kdesystemsettings.desktop"
          ]
          (_: {
            text = "[Desktop Entry]\nType=Application\nName=System Settings\nHidden=true\n";
          });
    };
}
