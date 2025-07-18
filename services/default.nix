{
  mkMerge,
  hyprlandEnabled,
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
mkMerge [
  {
    swaync.enable = hyprlandEnabled;
    cliphist.enable = hyprlandEnabled;
    hyprpaper.enable = hyprlandEnabled;
    hypridle.enable = hyprlandEnabled;
    hyprsunset.enable = hyprlandEnabled;
    swayosd.enable = hyprlandEnabled;
    playerctld.enable = true;
    psd.enable = true;
    podman.enable = true;
    easyeffects.enable = true;
    poweralertd.enable = true;
    network-manager-applet.enable = true;
    blueman-applet.enable = true;
  }
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
]
