{ pkgsUnstable, ... }:
{
  programs.ghostty = {
    enableZshIntegration = true;
    clearDefaultKeybinds = true;
    settings = {
      theme = "GitHub-Dark-High-Contrast";
      command = "${pkgsUnstable.zsh}/bin/zsh";
      font-family = "FiraCode Nerd Font Mono";
      font-size = 16;
      shell-integration-features = "no-cursor";
      cursor-style = "block";
      cursor-text = "#000000";
      cursor-style-blink = false;
      background-opacity = 0.95;
      background-blur = true;
    };
  };
}
