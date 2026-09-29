{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      programs.ghostty = {
        enable = lib.mkDefault true;

        settings = {
          background-opacity = lib.mkDefault 0.80;
          background-blur = true;
          font-size = 12;
          bell-features = "no-audio";
          theme = lib.mkDefault "Chalkboard";
          # theme = "Catppuccin Mocha";
          # theme = "Gruvbox Material Dark";
          # theme = "Everforest Dark Hard";
          cursor-style = "bar";
          confirm-close-surface = false;
          window-padding-balance = true;
          window-padding-y = 0;
          command = "/home/help/.nix-profile/bin/fish";
        };
      };
    };

  # Only on hyprland
  flake.modules.homeManager.hyprland = {
    programs.ghostty.settings.background-opacity = 0.95;
    programs.ghostty.settings.theme = "noctalia";
  };
}
