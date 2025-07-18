{
  waylandSystemdTarget,
  mpvpaper,
  preferedVideopaper,
}:
{
  services.mpvpaper = {
    Unit = {
      Conflicts = "hyprpaper.service";
      After = waylandSystemdTarget;
      PartOf = waylandSystemdTarget;
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };

    Service = {
      ExecStart = ''${mpvpaper}/bin/mpvpaper -vs -o "no-audio loop --ytdl-format=bv" ALL ${preferedVideopaper}'';
      Restart = "always";
      RestartSec = 10;
    };
  };
}
