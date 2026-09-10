{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.bash = {
    enable = lib.mkDefault true;
  };

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

  programs.starship = {
    enable = lib.mkDefault true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      add_newline = true;

      format = "$os$nix_shell$username$hostname[ ](bg:#c099ff)[](fg:#c099ff bg:#585b70)$directory[](fg:#585b70 bg:#45475a)$git_branch$git_status[](fg:#45475a bg:#313244)$nodejs$rust$golang$php[](fg:#313244 bg:#1e1e2e)$time[](fg:#1e1e2e) ";

      username = {
        show_always = true;
        style_user = "bg:#c099ff fg:#1e1e2e";
        style_root = "bg:#f38ba8 fg:#1e1e2e";
        format = "[ $user](bold $style)";
        disabled = false;
      };

      hostname = {
        ssh_only = true;
        style = "bg:#c099ff fg:#1e1e2e";
        format = "[@$hostname](bold $style)";
        disabled = false;
      };

      os = {
        disabled = false;
        style = "bg:#c099ff fg:#1e1e2e";
        format = "[ $symbol ]($style)";
        symbols = {
          Windows = "󰍲";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          AOSC = "";
          Arch = "󰣇";
          Artix = "󰣇";
          EndeavourOS = "";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
          Pop = "";
          Kali = "";
          NixOS = "";
        };
      };

      nix_shell = {
        disabled = false;
        style = "bg:#c099ff fg:#1e1e2e";
        format = "[\\( $name\\)](bold $style)";
        impure_msg = "impure";
        pure_msg = "pure";
        unknown_msg = "";
      };

      directory = {
        style = "fg:#cdd6f4 bg:#585b70";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = "";
        style = "bg:#45475a";
        format = "[[ $symbol $branch ](fg:#cba6f7 bg:#45475a)]($style)";
      };

      git_status = {
        style = "bg:#45475a";
        format = "[[($all_status$ahead_behind )](fg:#f9e2af bg:#45475a)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#313244";
        format = "[[ $symbol ($version) ](fg:#a6e3a1 bg:#313244)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#313244";
        format = "[[ $symbol ($version) ](fg:#fab387 bg:#313244)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#313244";
        format = "[[ $symbol ($version) ](fg:#89dceb bg:#313244)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:#313244";
        format = "[[ $symbol ($version) ](fg:#b4befe bg:#313244)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#1e1e2e";
        format = "[[ $time ](fg:#6c7086 bg:#1e1e2e)]($style)";
      };
    };
  };
}
