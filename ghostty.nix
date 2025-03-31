let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{
  programs.ghostty = {
    enableZshIntegration = true;
    clearDefaultKeybinds = true;
    settings = {
      theme = "GitHub-Dark-High-Contrast";
      command = "${pkgsUnstable.zsh}/bin/zsh";
      font-family = "FiraCode Nerd Font Mono";
      font-size = 16;
      cursor-opacity = 0.5;
      background-opacity = 0.95;
    };
  };
}
