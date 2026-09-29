{
  flake.modules.homeManager.hyprland =
    { lib, pkgs, ... }:

    {
      xdg.configFile."hypr" = {
        source = ./conf;
        recursive = true;
      };

      home.packages = with pkgs; [
        loupe
        papers
        kdePackages.breeze-icons
        bibata-cursors
        adw-gtk3
      ];

      dconf.settings."org/gnome/desktop/interface".icon-theme = "breeze-dark";
      home.activation.kdeIconTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kdeglobals --group Icons --key Theme breeze-dark
      '';

      xdg.mimeApps = {
        enable = true;
        defaultApplications =
          lib.genAttrs [
            "image/png"
            "image/jpeg"
            "image/gif"
            "image/webp"
            "image/avif"
            "image/heif"
            "image/bmp"
            "image/tiff"
            "image/svg+xml"
            "image/x-icon"
          ] (_: "org.gnome.Loupe.desktop")
          // lib.genAttrs [
            "application/pdf"
            "application/epub+zip"
            "image/vnd.djvu"
          ] (_: "org.gnome.Papers.desktop")
          // {
            "inode/directory" = "thunar.desktop";
          };
      };

      xdg.configFile."Thunar/uca.xml".text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <actions>
          <action>
            <icon>utilities-terminal</icon>
            <name>Abrir terminal aqui</name>
            <unique-id>ghostty-here</unique-id>
            <command>ghostty --working-directory=%f</command>
            <description>Abre o Ghostty nesta pasta</description>
            <patterns>*</patterns>
            <startup-notify/>
            <directories/>
          </action>
        </actions>
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
