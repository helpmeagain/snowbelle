# Esqueletos de projeto: `nix flake init -t ~/.dotfiles#python` numa pasta vazia.
{
  flake.templates = {
    python = {
      path = ../../templates/python;
      description = "Projeto Python com uv + devShell";
    };
    node = {
      path = ../../templates/node;
      description = "Projeto Node com pnpm + devShell";
    };
  };
}
