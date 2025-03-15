{ pkgs, ... }:
{
  services.hyprpaper = {
    enable = (import ../utils.nix).HYPRLAND_AVAILABLE;
    package = pkgs.hyprpaper;
    settings = {
      preload = "${./background.jpg}";
      wallpaper = ", ${./background.jpg}";
    };
  };
}
