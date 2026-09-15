{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      programs.zsh = {
        enable = lib.mkDefault true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        oh-my-zsh = {
          enable = true;
        };

        shellAliases = {
          ll = "ls -la";
          ".." = "cd ..";
          update = "sudo nixos-rebuild switch --flake $HOME/.dotfiles";
          hupdate = "home-manager switch --flake $HOME/.dotfiles";
        };

        initContent = ''
          if [[ -z "$TMUX" && $- == *i* ]]; then
            if [[ -n "$VSCODE_INJECTION" || "$TERM_PROGRAM" == "vscode" ]]; then
              tmux_session="vscode"
            else
              tmux_session="main"
            fi

            if tmux has-session -t "$tmux_session" 2>/dev/null; then
              if [[ "$tmux_session" == "main" && "$PWD" == "$HOME" ]]; then
                exec tmux attach-session -t "$tmux_session"
              else
                tmux_window_id=$(tmux new-window -Pt "$tmux_session" -c "$PWD" -F '#{window_id}')
                exec tmux attach-session -t "$tmux_session:$tmux_window_id"
              fi
            else
              exec tmux new-session -s "$tmux_session" -c "$PWD"
            fi
          fi
        '';
      };
    };
}
