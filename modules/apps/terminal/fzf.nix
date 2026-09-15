{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      programs.fzf = {
        enable = lib.mkDefault true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
    };
}
