{ pkgs, ... }:

{
  # Hipotético, só pra ver como fica um override de home-manager por host:
  # troca Bitwarden por KeePassXC só nesta máquina.
  dotfiles.excludePackages = [ pkgs.bitwarden-desktop ];
  home.packages = [ pkgs.keepassxc ];
}
