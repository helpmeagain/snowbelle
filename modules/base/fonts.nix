{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
          nerd-fonts.jetbrains-mono
          noto-fonts
          noto-fonts-cjk-sans-static
          noto-fonts-color-emoji
        ];
        fontconfig.defaultFonts = {
          monospace = [ "JetBrainsMono Nerd Font Mono" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
}
