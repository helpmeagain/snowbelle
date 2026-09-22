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
          background-opacity = 0.80;
          background-blur = true;
          font-size = 14;
          bell-features = "no-audio";
          theme = "Chalkboard";
          # theme = "Catppuccin Mocha";
          # theme = "Gruvbox Material Dark";
          # theme = "Everforest Dark Hard";
          cursor-style = "bar";
          confirm-close-surface = false;
        };
      };
    };
}
