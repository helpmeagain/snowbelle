{
  description = "NixOS + Home Manager, multi-host";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      plasma-manager,
      ...
    }:
    let
      lib = nixpkgs.lib;

      userSettings = {
        vscodePkg = "vscodium"; # vscode/vscodium
        wallpaper = "Imagens/Wallpapers/X.jpg";
        plasmaPanelStyle = "gnomeLike"; # "gnomeLike" | "windowsLike"
        firefoxVerticalTabs = true;
      };

      # desktop: "gnome" | "plasma" | "hyprland" | "none"
      # nixos:   true  -> também gera nixosConfigurations.<nome>
      #          false -> host não-NixOS (Nix em cima de Arch/Ubuntu, por exemplo), só gera home-manager standalone
      hosts = {
        notebook = {
          system = "x86_64-linux";
          desktop = "plasma";
          nixos = true;
        };
        thinkpad = {
          system = "x86_64-linux";
          desktop = "plasma";
          nixos = true;
        };
        # vm-dev      = { system = "x86_64-linux"; desktop = "none";  nixos = true;  };
        # arch-laptop = { system = "x86_64-linux"; desktop = "gnome"; nixos = false; };
      };

      systems = lib.unique (lib.mapAttrsToList (_: h: h.system) hosts);

      pkgsBySystem = lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
      pkgsUnstableBySystem = lib.genAttrs systems (system: nixpkgs-unstable.legacyPackages.${system});

      desktopModules = {
        none = {
          nixos = [ ];
          home = [ ];
        };
        gnome = {
          nixos = [ ./modules/desktop/gnome/nixos.nix ];
          home = [ ./modules/desktop/gnome/home.nix ];
        };
        plasma = {
          nixos = [ ./modules/desktop/plasma/nixos.nix ];
          home = [
            plasma-manager.homeModules.plasma-manager
            ./modules/desktop/plasma/home.nix
          ];
        };
        hyprland = {
          nixos = [ ./modules/desktop/hyprland/nixos.nix ];
          home = [ ./modules/desktop/hyprland/home.nix ];
        };
      };

      mkNixosHost =
        name: host:
        lib.nixosSystem {
          system = host.system;
          modules = [
            ./modules/nixos/common.nix
            ./hosts/${name}/default.nix
          ]
          ++ desktopModules.${host.desktop}.nixos;
          specialArgs = {
            pkgs-unstable = pkgsUnstableBySystem.${host.system};
          };
        };

      mkHomeConfig =
        name: host:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsBySystem.${host.system};
          modules = [
            ./modules/home/common.nix
          ]
          ++ desktopModules.${host.desktop}.home
          # override opcional por host, só entra se o arquivo existir
          ++ lib.optional (builtins.pathExists ./hosts/${name}/home.nix) ./hosts/${name}/home.nix;
          extraSpecialArgs = {
            pkgs-unstable = pkgsUnstableBySystem.${host.system};
            inherit userSettings;
            hostIsNixos = host.nixos;
          };
        };

      nixosHosts = lib.filterAttrs (_: h: h.nixos) hosts;
    in
    {
      nixosConfigurations = lib.mapAttrs mkNixosHost nixosHosts;

      homeConfigurations = lib.mapAttrs' (
        name: host: lib.nameValuePair "help@${name}" (mkHomeConfig name host)
      ) hosts;
    };
}
