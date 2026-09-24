{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      home.activation.invalidateZcompdump = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        rm -f "$HOME"/.zcompdump*
      '';

      programs.zsh = {
        enable = lib.mkDefault false;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        completionInit = ''autoload -Uz compinit && compinit -C -d "$HOME/.zcompdump-$ZSH_VERSION"'';

        shellAliases = {
          ll = "ls -la";
          ".." = "cd ..";
          update = "sudo nixos-rebuild switch --flake $HOME/.dotfiles";
          hupdate = "home-manager switch --flake $HOME/.dotfiles";
        };

        initContent = lib.mkMerge [
          (lib.mkOrder 550 ''
            if [[ -z "$TMUX" && $- == *i* ]] && (( $+commands[tmux] )); then
              if [[ -n "$VSCODE_INJECTION" || "$TERM_PROGRAM" == "vscode" ]]; then
                tmux_session="vscode"
              else
                tmux_session="main"
              fi

              if tmux has-session -t "$tmux_session" 2>/dev/null; then
                if [[ "$tmux_session" == "main" && "$PWD" != "$HOME" ]]; then
                  tmux_window_id=$(tmux new-window -Pt "$tmux_session" -c "$PWD" -F '#{window_id}')
                  tmux attach-session -t "$tmux_session:$tmux_window_id"
                else
                  tmux attach-session -t "$tmux_session"
                fi
              else
                tmux new-session -s "$tmux_session" -c "$PWD"
              fi
              tmux_rc=$?

              if (( tmux_rc == 0 )) && ! tmux has-session -t "$tmux_session" 2>/dev/null; then
                exit
              fi
            fi
          '')

          ''
            [[ -t 0 ]] && stty quit undef
            bindkey '^\' autosuggest-toggle
          ''
        ];
      };
    };
}
