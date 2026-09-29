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
          nix-switch = "sudo nixos-rebuild switch --flake $HOME/.dotfiles";
          hm-switch = "home-manager switch --flake $HOME/.dotfiles";
        };
      };
    };
}
