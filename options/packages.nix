{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages.gnome-rounded-blur = pkgs.callPackage ../modules/pkgs/gnome-rounded-blur.nix { };
      formatter = pkgs.nixfmt-rfc-style;
    };
}
