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
    preload = "${preferedWallpaper}";
    wallpaper = ",${preferedWallpaper}";
    ipc = "off";
  };
  swaync = {
    style = ./swaync.css;
    settings.timeout = 5;
  };
}
