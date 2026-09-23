{ inputs, ... }:

{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:

    {
      imports = [ inputs.noctalia.homeModules.default ];

      xdg.configFile."hypr" = {
        source = ./conf;
        recursive = true;
      };

      home.packages = with pkgs; [
        kdePackages.dolphin
        bibata-cursors
      ];

      programs.noctalia = {
        enable = true;
        systemd.enable = false;
        settings.shell.polkit_agent = true;
      };
    };
}
