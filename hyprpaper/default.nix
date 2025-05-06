let
  preferedWallpaper = ./wallpapers/Snow-valley.jpg;
in
{
  services.hyprpaper.settings = {
    preload = "${preferedWallpaper}";
    wallpaper = ",${preferedWallpaper}";
    ipc = "off";
  };
}
