{ pkgs, ... }:

# Exemplo de hosts/<nome>/default.nix (não é um host de verdade, serve de boilerplate)
{
  imports = [
    # Gerado com `sudo nixos-generate-config` na máquina nova, colado aqui do jeito que sair)
    ./hardware-configuration.nix
  ];

  # Precisa bater com o nome do host em flake.nix pros aliases `update`/
  networking.hostName = "example";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # Use a versão do instalador dessa máquina — nunca copie a de outro host.
  system.stateVersion = "26.05";
}
