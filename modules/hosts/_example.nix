# Modelo de host — não é uma máquina de verdade.
#
# O `_` no começo do nome faz o import-tree ignorar este arquivo. Para criar uma
# máquina nova: copie para `modules/hosts/<nome>/default.nix`, rode
# `sudo nixos-generate-config` na máquina e salve o resultado ao lado como
# `_hardware-configuration.nix` (o `_` de novo: ele é um módulo NixOS comum, não
# um módulo do flake-parts).
#
# Repare que uma máquina inteira cabe em um arquivo: o registro dela, o que ela
# tem de sistema e o que ela tem de usuário.
{
  # 1. Registra a máquina. É isto que faz `nixosConfigurations.example` e
  #    `homeConfigurations."help@example"` existirem.
  hosts.example = {
    desktop = "plasma"; # gnome | plasma | hyprland | none
    # system = "x86_64-linux";
    # nixos = false;    # máquina sem NixOS: gera só o homeConfigurations
  };

  # 2. O que é só desta máquina física, no nível do sistema.
  flake.modules.nixos."host/example" =
    { pkgs, ... }:
    {
      imports = [
        # Gerado com `sudo nixos-generate-config`, colado aqui do jeito que sair.
        ./_hardware-configuration.nix
      ];

      networking.hostName = "example";

      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };

        kernelPackages = pkgs.linuxPackages_latest;
      };

      # Use a versão do instalador dessa máquina — nunca copie a de outro host.
      system.stateVersion = "26.05";
    };

  # 3. Ajustes de usuário só desta máquina (opcional — pode apagar a seção).
  flake.modules.homeManager."host/example" =
    { pkgs, ... }:
    {
      # Pacotes exclusivos deste host
      home.packages = with pkgs; [
        keepassxc
      ];

      # Programas novos
      programs.tmux = {
        enable = true;
        shortcut = "a";
      };

      # Remove pacotes do conjunto padrão só neste host
      dotfiles.excludePackages = with pkgs; [
        bitwarden-desktop
      ];

      # Desliga um programa só neste host (dá certo porque a origem usa mkDefault)
      programs.starship.enable = false;

      # Sobrescreve um valor sem perder o resto (também por causa do mkDefault)
      programs.git.settings.user.name = "outro-user";
    };
}
