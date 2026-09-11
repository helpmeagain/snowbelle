{ pkgs, ... }:

{
  # Adicionar pacotes exclusivos para este host
  home.packages = with pkgs; [
    keepassxc
  ];

  # Para adicionar novos programs
  programs.tmux = {
    enable = true;
    shortcut = "a";
  };

  # Remover pacotes exclusivos para este host
  dotfiles.excludePackages = with pkgs; [
    bitwarden-desktop
  ];

  # Remove programas específicos só neste host (necessário lib.mkDefault na origem)
  programs.starship.enable = false;

  # Remove programas específicos só neste host
  # Só é possível porque "name" tem lib.mkDefault
  # Para testar que ainda permanceu outras configs: git config --list
  programs.git = {
    settings = {
      user = {
        name = "outro-user";
      };
    };
  };
}
