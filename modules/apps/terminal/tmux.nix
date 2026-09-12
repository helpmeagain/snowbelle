{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      programs.tmux = {
        enable = lib.mkDefault true;
        shortcut = "a";
        mouse = true;
        baseIndex = 1;
        terminal = "tmux-256color";

        extraConfig = ''
          # == BASIC SETTINGS ==
          set -ga terminal-overrides ",*:RGB"
          set -g set-clipboard on
          set-option -g renumber-windows on
          bind c new-window -c "#{pane_current_path}"

          # == BINDINGS ==
          # Splits
          bind \\ split-window -h -c "#{pane_current_path}"
          bind v split-window -v -c "#{pane_current_path}"

          # Reload
          unbind r
          bind r source-file $HOME/.config/tmux/tmux.conf

          unbind &
          bind X kill-window
          unbind x
          bind x kill-pane

          unbind f
          bind f resize-pane -Z

          # Sessions
          bind C command-prompt -p "New session name:" "new-session -s '%%'"

          bind-key b set-option status

          # VIM
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          bind -n M-h select-pane -L
          bind -n M-j select-pane -D
          bind -n M-k select-pane -U
          bind -n M-l select-pane -R

          bind -n M-Left previous-window
          bind -n M-Right next-window

          bind -n M-1 select-window -t 1
          bind -n M-2 select-window -t 2
          bind -n M-3 select-window -t 3
          bind -n M-4 select-window -t 4
          bind -n M-5 select-window -t 5
          bind -n M-6 select-window -t 6
          bind -n M-7 select-window -t 7
          bind -n M-8 select-window -t 8
          bind -n M-9 select-window -t 9

          # == STATUS BAR ==
          thm_bg="#222436"
          thm_fg="#c8d3f5"
          thm_cyan="#86e1fc"
          thm_black="#1b1d2b"
          thm_gray="#3a3f5a"
          thm_magenta="#c099ff"
          thm_pink="#ff757f"
          thm_red="#ff757f"
          thm_green="#c3e88d"
          thm_yellow="#ffc777"
          thm_blue="#82aaff"
          thm_orange="#ff9e64"
          thm_black4="#444a73"

          set -g status "on"
          set -g status-bg "''${thm_bg}"
          set -g status-justify "left"
          set -g status-left-length "100"
          set -g status-right-length "100"

          set -g pane-border-style "fg=''${thm_gray}"
          set -g pane-active-border-style "fg=''${thm_magenta}"

          set -g message-style "fg=''${thm_magenta},bg=''${thm_gray},align=centre"
          set -g message-command-style "fg=''${thm_magenta},bg=''${thm_gray},align=centre"

          set -g window-status-activity-style "fg=''${thm_fg},bg=''${thm_bg},none"
          set -g window-status-separator ""
          set -g window-status-style "fg=''${thm_fg},bg=''${thm_bg},none"

          set -g window-status-current-format "#[fg=''${thm_magenta},bg=''${thm_bg}] #I:#[fg=''${thm_fg},bg=''${thm_bg},bold]#W "
          set -g window-status-format "#[fg=''${thm_magenta},bg=''${thm_bg}] #I:#[fg=''${thm_black4},bg=''${thm_bg}]#W"

          set -g status-right "#[fg=''${thm_magenta},bg=''${thm_bg}]{#[fg=''${thm_fg}]#S#[fg=''${thm_magenta}]} #{?client_prefix,#[fg=''${thm_magenta}],#[fg=''${thm_black4}]}■ "
          set -g status-left ""
        '';
      };
    };
}
