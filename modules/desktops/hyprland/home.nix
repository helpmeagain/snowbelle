{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:

    {
      xdg.configFile."hypr" = {
        source = ./conf;
        recursive = true;
      };

      home.packages = with pkgs; [
        kdePackages.dolphin
        bibata-cursors
      ];
    };
}
