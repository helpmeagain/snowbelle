{ config, lib, ... }:

{
  options = {

    userSettings = lib.mkOption {
      description = "Preferências pessoais repassadas aos módulos home-manager.";
      type = lib.types.attrsOf lib.types.raw;
    };

    hosts = lib.mkOption {
      description = "Máquinas gerenciadas por este flake.";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {

            system = lib.mkOption {
              description = "Arquitetura do host.";
              type = lib.types.str;
              default = "x86_64-linux";
            };

            desktop = lib.mkOption {
              description = "Ambiente gráfico do host.";
              type = lib.types.enum [
                "gnome"
                "plasma"
                "hyprland"
                "none"
              ];
            };

            nixos = lib.mkOption {
              description = ''
                true  -> gera nixosConfigurations.<nome>
                false -> só homeConfigurations
              '';
              type = lib.types.bool;
              default = true;
            };

          };
        }
      );
    };

  };

  config = {
    systems = lib.unique (lib.mapAttrsToList (_: host: host.system) config.hosts);

    userSettings = {
      vscodePkg = "vscodium"; # vscode/vscodium
      wallpaper = "Imagens/Wallpapers/X.jpg";
      plasmaPanelStyle = "gnomeLike"; # "gnomeLike" | "windowsLike"
      firefoxVerticalTabs = true;
    };

    hosts = {
      notebook.desktop = "plasma";
      thinkpad.desktop = "plasma";
      desktop = {
        desktop = "plasma";
        nixos = false;
      };
    };

  };
}
