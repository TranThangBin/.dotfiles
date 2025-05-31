{ config, pkgs, ... }:
let
  mpvpaper = config.lib.nixGL.wrapOffload pkgs.mpvpaper;
  preferedVideopaper = ./videopapers/Stars.mp4;
in
{
  home.packages = [ mpvpaper ];

  systemd.user.services.mpvpaper = {
    Unit = {
      Conflicts = "hyprpaper.service";
      After = config.wayland.systemd.target;
      PartOf = config.wayland.systemd.target;
      ConditionalEnvironment = "WAYLAND_DISPLAY";
    };

    Service = {
      ExecStart = ''${mpvpaper}/bin/mpvpaper -vs -o "no-audio loop" ALL ${preferedVideopaper}'';
      Restart = "always";
      RestartSec = 10;
    };
  };
}
