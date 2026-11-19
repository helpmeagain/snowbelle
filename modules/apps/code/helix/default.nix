{
  flake.modules.homeManager.base = { pkgs, ... }: {
    dotfiles.packages = with pkgs; [ helix ];

    home.file = {
      ".config/helix/config.toml".text = ''
        theme = "tokyonight-transparent"

        [editor]
        true-color = true

        [editor.statusline]
        separator = " "
        left   = ["mode", "file-name", "file-modification-indicator"]
        center = []
        right  = ["diagnostics", "selections", "position"]

        [editor.statusline.mode]
        normal = "Normal"
        insert = "Insert"
        select = "Select"
      '';

      ".config/helix/themes/tokyonight-transparent.toml".text = ''
        inherits = "tokyonight"

        "ui.background" = {}

        "ui.statusline"= { fg = "#c8d3f5", bg = "#222436" }
      '';
    };
  };
}
