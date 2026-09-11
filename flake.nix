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
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
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
      system = "x86_64-linux";

      userSettings = {
        vscodePkg = "vscodium"; # vscode/vscodium
        wallpaper = "Imagens/Wallpapers/X.jpg";
        plasmaPanelStyle = "gnomeLike"; # "gnomeLike" | "windowsLike"
        firefoxVerticalTabs = true;
      };

      # desktop: "gnome" | "plasma" | "hyprland" | "none"
      # nixos:   true  -> também gera nixosConfigurations.<nome> | false -> host não-NixOS
      hosts = {
        notebook = {
          desktop = "plasma";
          nixos = true;
        };
        thinkpad = {
          desktop = "plasma";
          nixos = true;
        };
        desktop = {
          desktop = "plasma";
          nixos = false;
        };
      };

      pkgsBySystem = (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );

      pkgsUnstableBySystem = (
        system:
        import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        }
      );

      desktopModules = {
        none = {
          nixos = [ ];
          home = [ ];
        };
        gnome = {
          nixos = [ ./modules/profiles/gnome/nixos.nix ];
          home = [ ./modules/profiles/gnome/home.nix ];
        };
        plasma = {
          nixos = [ ./modules/profiles/plasma/nixos.nix ];
          home = [
            plasma-manager.homeModules.plasma-manager
            ./modules/profiles/plasma/home.nix
          ];
        };
        hyprland = {
          nixos = [ ./modules/profiles/hyprland/nixos.nix ];
          home = [ ./modules/profiles/hyprland/home.nix ];
        };
      };

      mkNixosHost =
        name: host:
        lib.nixosSystem {
          system = system;
          pkgs = pkgsBySystem system;
          modules = [
            ./modules/commonConfiguration.nix
            ./modules/hosts/${name}/default.nix
          ]
          ++ desktopModules.${host.desktop}.nixos;
          specialArgs = {
            pkgs-unstable = pkgsUnstableBySystem system;
          };
        };

      mkHomeConfig =
        name: host:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsBySystem system;
          modules = [
            ./modules/commonHome.nix
          ]
          ++ desktopModules.${host.desktop}.home
          # override opcional por host, só entra se o arquivo existir
          ++ lib.optional (builtins.pathExists ./modules/hosts/${name}/home.nix) ./modules/hosts/${name}/home.nix;
          extraSpecialArgs = {
            pkgs-unstable = pkgsUnstableBySystem system;
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
