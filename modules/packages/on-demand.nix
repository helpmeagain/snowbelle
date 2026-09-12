{
  perSystem =
    { pkgs, ... }:
    {
      # nix run ~/.dotfiles#chrome
      packages.chrome = pkgs.google-chrome;
    };
}
