{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      programs.bash = {
        enable = lib.mkDefault true;

        shellAliases = {
          update = "sudo nixos-rebuild switch --flake $HOME/.dotfiles";
          hupdate = "home-manager switch --flake $HOME/.dotfiles";
        };
      };
    };
}
