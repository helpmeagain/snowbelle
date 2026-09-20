{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      fonts.fontconfig.enable = true;
      home.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-cjk-sans-static
        noto-fonts-color-emoji
      ];
    };
}
