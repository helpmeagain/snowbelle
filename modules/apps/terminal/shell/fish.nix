{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      programs.fish = {
        enable = lib.mkDefault true;
        shellAbbrs = {
          update = "sudo nixos-rebuild switch --flake $HOME/.dotfiles";
          hupdate = "home-manager switch --flake $HOME/.dotfiles";
        };
        interactiveShellInit = ''
          set -g fish_greeting

          if not set -q TMUX; and status is-interactive; and type -q tmux
            if test -n "$VSCODE_INJECTION"; or test "$TERM_PROGRAM" = vscode
              set tmux_session vscode
            else
              set tmux_session main
            end

            set tmux_marker "$HOME/.tmux-manual-detach"
            rm -f $tmux_marker

            if tmux has-session -t $tmux_session 2>/dev/null
              if test "$tmux_session" = main; and test "$PWD" != "$HOME"
                set tmux_window_id (tmux new-window -Pt $tmux_session -c "$PWD" -F '#{window_id}')
                tmux attach-session -t "$tmux_session:$tmux_window_id"
              else
                tmux attach-session -t $tmux_session
              end
            else
              tmux new-session -s $tmux_session -c "$PWD"
            end

            if test -e $tmux_marker
              rm -f $tmux_marker
            else
              exec true
            end
          end
        '';
      };
    };
}
