{ config, lib, ... }:
let
  hyprland = config.wayland.windowManager.hyprland;
  hyprsunsetTransitions = {
    sunrise = {
      calendar = "*-*-* 06:00:00";
      requests = [
        [
          "temperature"
          "6000"
        ]
      ];
    };
    sunset = {
      calendar = "*-*-* 19:00:00";
      requests = [
        [
          "temperature"
          "4000"
        ]
      ];
    };
  };
in
{
  wayland.systemd.target = "wayland-session@hyprland.desktop.target";

  i18n.inputMethod.fcitx5.waylandFrontend = hyprland.enable;

  services.swaync = {
    style = ./swaync.css;
    settings.timeout = 5;
  };
  services.cliphist.systemdTargets = config.wayland.systemd.target;
  systemd.user = lib.mkIf hyprland.enable {
    services = lib.mapAttrs' (
      name: transitionCfg:
      lib.nameValuePair "hyprsunset-${name}" {
        Install = { };
        Unit = {
          ConditionEnvironment = "WAYLAND_DISPLAY";
          Description = "hyprsunset transition for ${name}";
          After = [ "hyprsunset.service" ];
          Requires = [ "hyprsunset.service" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = lib.concatMapStringsSep " && " (
            cmd: "hyprctl hyprsunset ${lib.escapeShellArgs cmd}"
          ) transitionCfg.requests;
        };
      }
    ) hyprsunsetTransitions;
    timers = lib.mapAttrs' (
      name: transitionCfg:
      lib.nameValuePair "hyprsunset-${name}" {
        Install = {
          WantedBy = [ config.wayland.systemd.target ];
        };

        Unit = {
          Description = "Timer for hyprsunset transition (${name})";
        };

        Timer = {
          OnCalendar = transitionCfg.calendar;
          Persistent = true;
        };
      }
    ) hyprsunsetTransitions;
  };

  home.pointerCursor.hyprcursor.enable = hyprland.enable;

  xdg.portal.config = {
    common.default = [ "hyprland" ];
    hyprland.default = [ "hyprland" ];
  };

  xdg.configFile."uwsm/env".enable = hyprland.enable;
  xdg.configFile."uwsm/env-hyprland".enable = hyprland.enable;

  xdg.configFile."uwsm/env".text = ''
    export ALSA_PLUGIN_DIR=${config.lib.packages.pipewire}/lib/alsa-lib
    export ELECTRON_OZONE_PLATFORM_HINT=wayland
  '';
  xdg.configFile."uwsm/env-hyprland".text = with import ./gpu-env.nix; ''
    export GBM_BACKEND=${GBM_BACKEND}
    export __GLX_VENDOR_LIBRARY_NAME=${__GLX_VENDOR_LIBRARY_NAME}
    export LIBVA_DRIVER_NAME=${LIBVA_DRIVER_NAME}
    export AQ_DRM_DEVICES=${lib.concatStringsSep ":" AQ_DRM_DEVICES}
  '';

  imports = [
    ./config.nix
    ./hyprpaper.nix
    ./hypridle.nix
  ];
}
