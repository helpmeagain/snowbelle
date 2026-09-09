{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "thinkpad";

  boot = {
    loader = {
      systemd-boot.enable = false;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 2;
        extraEntries = ''
          menuentry "Ubuntu" {
            insmod part_gpt
            insmod fat
            insmod chain
            chainloader /EFI/ubuntu/shimx64.efi
          }
        '';
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };

    initrd.systemd.enable = true;

    plymouth.enable = true;
    kernelParams = [
      "quiet"
      "transparent_hugepage=never"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.xserver.xkb = {
    layout = "br";
    variant = "thinkpad";
  };

  hardware.bluetooth.enable = true;
  virtualisation = {
    docker.enable = true;
    vmware.host.enable = true;
  };

  environment.systemPackages = [
    pkgs.distrobox
  ];

  fileSystems."/mnt/shared" = {
    device = "/dev/disk/by-uuid/FEFF-C7E9";
    fsType = "exfat";
    options = [
      "uid=1000"
      "gid=100"
      "umask=0022"
      "nofail"
      "x-systemd.device-timeout=5s"
    ];
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
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
