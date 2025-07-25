{
  waylandSystemdTarget,
  podman-compose,
  systemd,
  systemctlPath,
  brightnessctl,
  playerctl,
  pidofBin,
  hyprlockBin,
  hyprctlBin,
  preferedWallpaper,
  swayosd,
}:
{
  hypridle = import ./hypridle.nix {
    inherit
      pidofBin
      hyprlockBin
      systemd
      hyprctlBin
      systemctlPath
      brightnessctl
      playerctl
      ;
  };
  easyeffects = import ./easyeffects.nix;
  cliphist.systemdTargets = waylandSystemdTarget;
  poweralertd.extraArgs = [
    "-s"
    "-S"
  ];
  podman.settings.containers.network.compose_providers = [
    "${podman-compose}/bin/podman-compose"
  ];
  hyprpaper.settings = {
    "$hyprpaperBg" = "${preferedWallpaper}";
    ipc = "off";
    preload = "$hyprpaperBg";
    wallpaper = ",$hyprpaperBg";
  };
  swaync = {
    settings.timeout = 5;
    style = ./swaync.css;
  };
  swayosd.stylePath = "${swayosd}/etc/xdg/swayosd/style.css";
}
