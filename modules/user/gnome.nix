{ config, pkgs, ... }:

let
    myExtensions = with pkgs.gnomeExtensions; [
        dash-to-dock
        blur-my-shell
        appindicator
    ];
in

{
    home.packages = myExtensions ++ [ pkgs.yaru-theme ];

    dconf = {
        enable = true;

        settings."org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = map (ext: ext.extensionUuid) myExtensions;
        };
        
        settings."org/gnome/desktop/interface" = {
            monospace-font-name = "JetBrainsMono Nerd Font 11";
            color-scheme = "prefer-dark";
            icon-theme = "Yaru";
        };
    };
}