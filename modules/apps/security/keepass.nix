{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.keepassxc = {
        enable = lib.mkDefault true;
        #    settings = {
        #      Browser = {
        #        Enabled = true;
        #      };
        #    };
      };
    };
}
