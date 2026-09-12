# Descrição da estrutura dos hosts
{ config, lib, ... }:

{
  options.hosts = lib.mkOption {
    description = "Máquinas gerenciadas por este flake.";
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {

          system = lib.mkOption {
            description = "Arquitetura do host.";
            type = lib.types.str;
            default = "x86_64-linux";
          };

          desktop = lib.mkOption {
            description = ''
              Ambiente gráfico do host: o nome de um aspecto declarado em
              modules/desktops/, ou "none".
            '';
            type = lib.types.str;
            default = "none";
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

  # systems do flake-parts sai da lista de hosts
  config.systems = lib.unique (lib.mapAttrsToList (_: host: host.system) config.hosts);
}
