{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.mpv = {
        enable = lib.mkDefault true;

        config = {
          hwdec = "auto-safe";
          ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
          save-position-on-quit = true;
          screenshot-directory = "~/Imagens/Capturas de tela";
          screenshot-format = "png";
          sub-auto = "fuzzy";
          volume-max = 200;
          volume = 100;
          osc = false;
          osd-bar = false;
          border = false;
        };

        scripts = with pkgs.mpvScripts; [
          uosc
          mpris
          thumbfast
        ];

        bindings = {
          "F12" = "screenshot";
          "Shift+F12" = "screenshot window";
          "Ctrl+F12" = "screenshot video";
          "s" = "ignore";
          "S" = "ignore";
          "Ctrl+s" = "ignore";
        };
      };

      xdg.mimeApps = {
        enable = lib.mkDefault true;
        defaultApplications = lib.genAttrs [
          "video/mp4"
          "video/x-matroska"
          "video/webm"
          "video/quicktime"
          "video/x-msvideo"
          "video/mpeg"
          "video/ogg"
          "video/3gpp"
          "video/x-flv"
          "audio/mpeg"
          "audio/mp4"
          "audio/ogg"
          "audio/flac"
          "audio/x-wav"
          "audio/webm"
          "application/ogg"
        ] (_: "mpv.desktop");
      };
    };
}
