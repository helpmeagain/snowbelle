{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "help";
  home.homeDirectory = "/home/help";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/help/etc/profile.d/hm-session-vars.sh
  #
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      ".." = "cd ..";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "helpmeagain";
        email = "57302703+helpmeagain@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
  
  programs.starship = {
    enable = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      add_newline = false;

      format = "$username$os$hostname[](fg:#c099ff bg:#585b70)$directory[](fg:#585b70 bg:#45475a)$git_branch$git_status[](fg:#45475a bg:#313244)$nodejs$rust$golang$php[](fg:#313244 bg:#1e1e2e)$time[](fg:#1e1e2e) ";

      username = {
        show_always = true;
        style_user = "bg:#c099ff fg:#1e1e2e";
        style_root = "bg:#f38ba8 fg:#1e1e2e";
        format = "[ $user ](bold $style)";
        disabled = false;
      };

      hostname = {
        ssh_only = false;
        style = "bg:#c099ff fg:#1e1e2e";
        format = "[$hostname ](bold $style)";
        disabled = false;
      };

      os = {
        disabled = false;
        style = "bg:#c099ff fg:#1e1e2e";
        format = "[$symbol ]($style)";
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
          Kali = " ";
          NixOS = " ";
        };
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

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
