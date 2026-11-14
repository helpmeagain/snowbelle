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
          nix-switch = "sudo nixos-rebuild switch --flake $HOME/Projetos/Repositórios/snowbelle";
          hm-switch = "home-manager switch --flake $HOME/Projetos/Repositórios/snowbelle";
          fl-update = "nix flake update --flake $HOME/Projetos/Repositórios/snowbelle";
        };
      };
    };
}
