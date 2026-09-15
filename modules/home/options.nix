{
  flake.modules.homeManager.base =
    { lib, ... }:
    {
      options.dotfiles = {

        wallpaper = lib.mkOption {
          description = "Papel de parede, relativo a `$HOME`.";
          type = lib.types.str;
        };

        isNixos = lib.mkOption {
          description = ''
            Se este home roda sobre NixOS. Preenchido pelo montador a partir de
            `hosts.<nome>.nixos`; não mexa aqui.
          '';
          type = lib.types.bool;
          default = false;
        };

        vscode.package = lib.mkOption {
          description = "Qual edição do VS Code instalar.";
          type = lib.types.enum [
            "vscode"
            "vscodium"
          ];
        };

        firefox.verticalTabs = lib.mkOption {
          description = "Usa a barra de abas vertical na sidebar.";
          type = lib.types.bool;
          default = true;
        };

        plasma.panelStyle = lib.mkOption {
          description = ''
            "gnomeLike"   -> barra fina no topo + dock flutuante embaixo
            "windowsLike" -> barra única embaixo
          '';
          type = lib.types.enum [
            "gnomeLike"
            "windowsLike"
          ];
          default = "gnomeLike";
        };

      };

      config.dotfiles = import ../../settings.nix;
    };
}
