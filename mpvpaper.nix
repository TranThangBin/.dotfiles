{ config, ... }:
let
  mpvpaper = config.programs.mpvpaper.package;
  preferedVideopaper = "https://youtu.be/YhUPi6-MQNE?si=zS7PKwOmwxQeGQhf";
in
{
  programs.mpvpaper = {
    pauseList = " ";
    stopList = ''
      steam
      wineserver
    '';
  };
  systemd.user.services.mpvpaper = {
    Unit = {
      Conflicts = "hyprpaper.service";
      After = config.wayland.systemd.target;
      PartOf = config.wayland.systemd.target;
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };

    Service = {
      ExecStart = ''${mpvpaper}/bin/mpvpaper -vs -o "no-audio loop --ytdl-format=bv" ALL ${preferedVideopaper}'';
      Restart = "always";
      RestartSec = 10;
    };
  };
}
