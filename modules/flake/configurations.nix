# Transforma cada entrada de hosts numa configuração. Os arquivo despejam em três nomes de aspectom base`, o nome do desktop e `host/<nome>`
{
  config,
  lib,
  inputs,
  withSystem,
  ...
}:

let
  inherit (config.flake) modules;

  # O aspecto name da classe class, se algum arquivo tiver declarado ele.
  pick = class: name: lib.optional ((modules.${class} or { }) ? ${name}) modules.${class}.${name};

  desktopOf =
    name: host:
    if
      host.desktop == "none"
      || (modules.nixos or { }) ? ${host.desktop}
      || (modules.homeManager or { }) ? ${host.desktop}
    then
      host.desktop
    else
      throw ''host "${name}": desktop "${host.desktop}" não tem módulo em modules/desktops/.'';

  mkNixosHost =
    name: host:
    withSystem host.system (
      { pkgs, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit pkgs;
        modules = [
          modules.nixos.base
        ]
        ++ pick "nixos" (desktopOf name host)
        ++ pick "nixos" "host/${name}";
      }
    );

  mkHomeConfig =
    name: host:
    withSystem host.system (
      { pkgs, ... }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          modules.homeManager.base
          { dotfiles.isNixos = host.nixos; }
        ]
        ++ pick "homeManager" (desktopOf name host)
        ++ pick "homeManager" "host/${name}";
      }
    );

in

{
  flake = {
    nixosConfigurations = lib.mapAttrs mkNixosHost (lib.filterAttrs (_: host: host.nixos) config.hosts);

    homeConfigurations = lib.mapAttrs' (
      name: host: lib.nameValuePair "help@${name}" (mkHomeConfig name host)
    ) config.hosts;
  };
}
