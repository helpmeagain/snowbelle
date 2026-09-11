{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:
let
  vscodePkg = userSettings.vscodePkg;
  isProprietary = vscodePkg == "vscode";

  vscodeTmuxTerminal = pkgs.writeShellScriptBin "vscode-tmux-terminal" ''
    #!/usr/bin/env bash
    set -e
    if tmux has-session -t vscode 2>/dev/null; then
      window_id=$(tmux new-window -Pt vscode -F '#{window_id}')
      exec tmux attach-session -t "vscode:$window_id"
    else
      exec tmux new-session -s vscode
    fi
  '';
in
{
  home.packages = [ vscodeTmuxTerminal ];

  programs.${vscodePkg} = {
    enable = lib.mkDefault true;
    profiles.default = {
      extensions =
        with pkgs.vscode-extensions;
        [
          jnoortheen.nix-ide
          anthropic.claude-code
          pkief.material-icon-theme
          ms-python.python
          ms-python.vscode-python-envs
          ms-python.debugpy
          ms-vscode.cpptools
        ]
        ++ lib.optionals isProprietary [

        ];
      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
        "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";
        "[nix]"."editor.formatOnSave" = true;
        "terminal.integrated.mouseWheelScrollSensitivity" = 3;
        "terminal.integrated.gpuAcceleration" = "off";
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.editor.labelFormat" = "short";
        "workbench.activityBar.location" = "top";
        "breadcrumbs.enabled" = false;
        "workbench.statusBar.visible" = true;
        "window.titleBarStyle" = "custom";
        "telemetry.telemetryLevel" = "off";
        "editor.fontLigatures" = true;
        "chat.disableAIFeatures" = true;
        "chat.agent.enabled" = false;
        "terminal.integrated.profiles.linux" = {
          "tmux (vscode session)" = {
            path = "${vscodeTmuxTerminal}/bin/vscode-tmux-terminal";
          };
        };
        "terminal.integrated.defaultProfile.linux" = "tmux (vscode session)";
      };
    };
  };
}
