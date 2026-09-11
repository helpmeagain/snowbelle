{ lib, inputs, ... }:

{
  options.desktopModules = lib.mkOption {
    description = "Módulos NixOS e home-manager de cada ambiente gráfico.";
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          nixos = lib.mkOption {
            description = "Módulos NixOS do ambiente.";
            type = lib.types.listOf lib.types.raw;
            default = [ ];
          };
          home = lib.mkOption {
            description = "Módulos home-manager do ambiente.";
            type = lib.types.listOf lib.types.raw;
            default = [ ];
          };
        };
      }
    );
  };

  config.desktopModules = {

    none = { };

    gnome = {
      nixos = [ ../modules/profiles/gnome/nixos.nix ];
      home = [ ../modules/profiles/gnome/home.nix ];
    };

    plasma = {
      nixos = [ ../modules/profiles/plasma/nixos.nix ];
      home = [
        inputs.plasma-manager.homeModules.plasma-manager
        ../modules/profiles/plasma/home.nix
      ];
    };

    hyprland = {
      nixos = [ ../modules/profiles/hyprland/nixos.nix ];
      home = [ ../modules/profiles/hyprland/home.nix ];
    };

  };
}
