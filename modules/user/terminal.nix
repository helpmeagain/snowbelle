{ config, lib, pkgs, ... }:
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
  };

  programs.starship = {
    enable = lib.mkDefault true;
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
}
