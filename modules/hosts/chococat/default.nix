{
  # A máquina inteira num arquivo: o registro dela...
  hosts.chococat = {
    desktop = "plasma";
  };

  # ...e o que ela tem de sistema.
  flake.modules.nixos."host/chococat" =
    { pkgs, ... }:

    {
      imports = [
        ./_hardware-configuration.nix
      ];

      networking.hostName = "chococat";

      boot = {
        loader = {
          timeout = 15;
          efi.canTouchEfiVariables = true;

          limine = {
            enable = true;
            secureBoot.enable = true;
            maxGenerations = 10;

            extraConfig = ''
              remember_last_entry: yes
            '';

            extraEntries = ''
              /Windows 11
                  protocol: efi
                  path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
            '';

            style = {
              wallpapers = [ ];
            };
          };
        };

        initrd = {
          systemd.enable = true;
          luks.devices."luks-bed24996-8ea5-4647-8644-feff91fdfa19".allowDiscards = true;
        };

        plymouth.enable = true;
        kernelParams = [
          "quiet"
          "transparent_hugepage=never"
        ];
        kernelPackages = pkgs.linuxPackages_latest;
      };

      environment.etc.crypttab.text = ''
        HDD1 UUID=420bfc6e-6fcb-479e-8aef-bb6a2530b944 /etc/nixos/dados.key luks,nofail
        HDD2 UUID=bc08958b-5a5b-4abf-9c3b-5762842dc308 /etc/nixos/dados.key luks,nofail
        HDD3 UUID=fd2fdc7c-8901-4d65-8001-d45a6d81f0a0 /etc/nixos/dados.key luks,nofail
        SSD1 UUID=69837a79-1659-46a7-a831-57ebd69dcc55 /etc/nixos/dados.key luks,nofail,discard
      '';

      fileSystems."/mnt/HDD1" = {
        device = "/dev/mapper/HDD1";
        fsType = "ext4";
        options = [ "nofail" ];
      };

      fileSystems."/mnt/HDD2" = {
        device = "/dev/mapper/HDD2";
        fsType = "ext4";
        options = [ "nofail" ];
      };

      fileSystems."/mnt/HDD3" = {
        device = "/dev/mapper/HDD3";
        fsType = "ext4";
        options = [ "nofail" ];
      };

      fileSystems."/mnt/SSD1" = {
        device = "/dev/mapper/SSD1";
        fsType = "ext4";
        options = [ "nofail" ];
      };

      services.xserver.xkb = {
        layout = "br";
        variant = "";
      };

      programs.steam = {
        enable = true;
      };

      environment.systemPackages = with pkgs; [
        sbctl
      ];

      hardware.bluetooth.enable = true;

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
      # This value being lower than the current NixOS release does NOT mean your system is
      # out of date, out of support, or vulnerable.
      #
      # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
      # and migrated your data accordingly.
      #
      # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
      system.stateVersion = "26.05"; # Did you read the comment?
    };
}
