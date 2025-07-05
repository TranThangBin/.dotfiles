{ zsh }:
{
  enableZshIntegration = true;
  clearDefaultKeybinds = true;
  installBatSyntax = true;
  installVimSyntax = true;
  settings = {
    theme = "GitHub-Dark-High-Contrast";
    command = "${zsh}/bin/zsh";
    font-family = "FiraCode Nerd Font Mono";
    font-size = 16;
    shell-integration-features = "no-cursor";
    cursor-style = "block";
    cursor-text = "#000000";
    cursor-style-blink = false;
    background-opacity = 0.95;
    background-blur = true;
    custom-shader = [ ];
    keybind = [
      "ctrl+equal=increase_font_size:1"
      "ctrl+minus=decrease_font_size:1"
      "ctrl+zero=reset_font_size"
      "ctrl+shift+v=paste_from_clipboard"
      "ctrl+shift+c=copy_to_clipboard"
    ];
  };
}
