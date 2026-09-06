{ config, pkgs, ... }:
let
  editor = "vscodium";
  #editor = "vscode";
in
{
  programs.${editor} = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        anthropic.claude-code
        pkief.material-icon-theme
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
        "symbols.hidesExplorerArrows" = false;
        "chat.disableAIFeatures" = true;
        "chat.agent.enabled" = false;
      };
    };
  };
}
