{ common, packages }:
{
  hypridle = import ./hypridle.nix {
    inherit (common) systemctlPath;
    inherit (packages.hyprlandExtra) hyprland;
    inherit (packages)
      brightnessctl
      playerctl
      systemd
      toybox
      ;
  };
  easyeffects = import ./easyeffects.nix;
  cliphist.systemdTargets = common.waylandSystemdTarget;
  poweralertd.extraArgs = [
    "-s"
    "-S"
  ];
  podman.settings.containers.network.compose_providers = [
    "${packages.podmanExtra.podman-compose}/bin/podman-compose"
  ];
  hyprpaper.settings = {
    "$hyprpaperBg" = "${common.preferedWallpaper}";
    ipc = "off";
    preload = "$hyprpaperBg";
    wallpaper = ",$hyprpaperBg";
  };
  swaync = {
    settings.timeout = 5;
    style = ./swaync.css;
  };
  swayosd.stylePath = "${packages.swayosd}/etc/xdg/swayosd/style.css";
}
