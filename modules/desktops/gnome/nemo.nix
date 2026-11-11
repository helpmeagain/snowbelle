{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      isProprietaryVscode = config.dotfiles.vscode.package == "vscode";
      vscodeBin = if isProprietaryVscode then "code" else "codium";
      vscodeIcon = if isProprietaryVscode then "vscode" else "vscodium";
      vscodeName = if isProprietaryVscode then "Visual Studio Code" else "VSCodium";
    in
    {
      home.packages = with pkgs; [
        nemo-with-extensions
        file-roller
        ffmpeg-headless
        ffmpegthumbnailer
      ];

      home.file = {
        ".local/share/nemo/actions/open-in-vscodium.nemo_action".text = ''
          [Nemo Action]
          Name=Abrir em ${vscodeName}
          Comment=Abrir arquivos ou pastas selecionados no editor
          Exec=${vscodeBin} %F
          Icon-Name=${vscodeIcon}
          Selection=any
          Extensions=any;
          Dependencies=${vscodeBin};
        '';

        ".local/share/nemo/actions/open-current-folder-in-vscodium.nemo_action".text = ''
          [Nemo Action]
          Name=Abrir pasta atual em ${vscodeName}
          Comment=Abrir a pasta atual como projeto
          Exec=${vscodeBin} %P
          Icon-Name=${vscodeIcon}
          Selection=none
          Dependencies=${vscodeBin};
        '';

        ".local/share/nemo/actions/copy-absolute-path.nemo_action".text = ''
          [Nemo Action]
          Name=Copiar caminho absoluto
          Comment=Copiar caminho completo dos arquivos selecionados
          Exec=${config.home.homeDirectory}/.local/bin/nemo-copy-path %F
          Icon-Name=edit-copy
          Selection=any
          Extensions=any;
          Dependencies=wl-copy;
        '';

        ".local/share/nemo/actions/copy-current-folder-path.nemo_action".text = ''
          [Nemo Action]
          Name=Copiar caminho da pasta atual
          Comment=Copiar caminho absoluto da pasta atual
          Exec=${config.home.homeDirectory}/.local/bin/nemo-copy-path %P
          Icon-Name=edit-copy
          Selection=none
          Dependencies=wl-copy;
        '';
      };
    };
}
