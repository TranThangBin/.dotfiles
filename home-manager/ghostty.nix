{ config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    clearDefaultKeybinds = true;
    package = (config.lib.nixGL.wrap pkgs.ghostty);
    settings = {
      theme = "GitHub-Dark-High-Contrast";
      command = "${config.programs.zsh.package}/bin/zsh";
      font-family = "FiraCode Nerd Font Mono";
      font-size = 16;
      cursor-opacity = 0.5;
      background-opacity = 0.95;
    };
  };
}
