# Montagem: transforma cada entrada de `hosts` numa configuração de verdade.
{
  config,
  lib,
  inputs,
  withSystem,
  ...
}:

let
  mkNixosHost =
    name: host:
    withSystem host.system (
      { pkgs, pkgs-unstable, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit pkgs;
        system = host.system;
        modules = [
          ../modules/commonConfiguration.nix
          ../modules/hosts/${name}/default.nix
        ]
        ++ config.desktopModules.${host.desktop}.nixos;
        specialArgs = {
          inherit pkgs-unstable;
        };
      }
    );

  mkHomeConfig =
    name: host:
    withSystem host.system (
      { pkgs, pkgs-unstable, ... }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ../modules/commonHome.nix
        ]
        ++ config.desktopModules.${host.desktop}.home
        # override opcional por host, só entra se o arquivo existir
        ++ lib.optional (builtins.pathExists ../modules/hosts/${name}/home.nix) ../modules/hosts/${name}/home.nix;
        extraSpecialArgs = {
          inherit pkgs-unstable;
          inherit (config) userSettings;
          hostIsNixos = host.nixos;
        };
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
