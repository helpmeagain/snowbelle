{ pkgs, ... }:

{
  # STUB — deliberadamente vazio. O home-manager de base não tem um módulo
  # `programs.plasma`; configuração declarativa de Plasma (painéis, atalhos,
  # kwin) exige o input externo `nix-community/plasma-manager`, que ainda não
  # foi adicionado a este flake. Escrever uma opção inexistente aqui pareceria
  # funcionar sem fazer nada — pior que deixar vazio até esse input existir.
}
