{ pkgs, ... }:
{
  services.hyprpaper = {
    enable = builtins.pathExists "/usr/bin/Hyprland";
    package = pkgs.hyprpaper;
    settings = {
      preload = "${./background.jpg}";
      wallpaper = ", ${./background.jpg}";
    };
  };
}
