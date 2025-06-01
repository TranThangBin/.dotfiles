{ config, ... }:
{
  programs.kitty = {
    shellIntegration = {
      enableZshIntegration = true;
      mode = "no-cursor";
    };
    themeFile = "GitHub_Dark_High_Contrast";
    font = {
      name = "FiraCode Nerd Font Mono";
      size = 16;
    };
    settings = {
      shell = "${config.programs.zsh.package}/bin/zsh";
      cursor_shape = "block";
      cursor_shape_unfocused = "block";
      cursor_blink_interval = 0;
      background_opacity = 0.8;
      background_blur = 20;
    };
  };
}
