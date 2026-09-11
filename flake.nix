{
  description = "NixOS + Home Manager, multi-host";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./options/settings.nix # userSettings, hosts, systems
        ./options/desktops.nix # ambientes gráficos
        ./options/nixpkgs.nix # como o nixpkgs é instanciado
        ./options/packages.nix # packages, formatter
        ./options/configurations.nix # montagem
      ];
    };
}
