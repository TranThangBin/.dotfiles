{
  config,
  lib,
  pkgs,
  ...
}:
let
  hyprland = config.wayland.windowManager.hyprland;
  systemd = pkgs.systemd;
  systemctl = config.systemd.user.systemctlPath;
  hyprlandDestkop = (
    assert lib.pathExists "/usr/share/wayland-sessions/hyprland.desktop";
    "hyprland.desktop"
  );
in
{
  wayland.systemd.target = "wayland-session@hyprland.desktop.target";

  home.packages = lib.mkIf hyprland.enable (
    with pkgs;
    [
      uwsm
      hyprshot
      hyprpicker
      wofi-emoji
    ]
  );

  programs.hyprlock.enable = hyprland.enable;
  programs.waybar.enable = hyprland.enable;
  programs.wofi.enable = hyprland.enable;
  programs.wlogout.enable = hyprland.enable;

  programs.hyprlock.package = pkgs.emptyDirectory; # Manage hyprlock with your os package manager

  i18n.inputMethod.fcitx5.waylandFrontend = hyprland.enable;

  programs.wofi.settings = {
    hide_scroll = true;
    insensitive = true;
    allow_images = true;
    style = "${./wofi.css}";
    key_expand = "Ctrl-space";
  };

  programs.wlogout.layout = [
    {
      label = "lock";
      action = "${systemd}/bin/loginctl lock-session";
      text = "Lock";
      keybind = "l";
    }
    {
      label = "hibernate";
      action = "${systemctl} hibernate";
      text = "Hibernate";
      keybind = "h";
    }
    {
      label = "logout";
      action = "${pkgs.uwsm}/bin/uwsm stop";
      text = "Logout";
      keybind = "e";
    }
    {
      label = "shutdown";
      action = "${systemctl} poweroff";
      text = "Shutdown";
      keybind = "s";
    }
    {
      label = "suspend";
      action = "${systemctl} suspend";
      text = "Suspend";
      keybind = "u";
    }
    {
      label = "reboot";
      action = "${systemctl} reboot";
      text = "Reboot";
      keybind = "r";
    }
  ];

  services.swaync.enable = hyprland.enable;
  services.cliphist.enable = hyprland.enable;
  services.hyprpaper.enable = hyprland.enable;
  services.hypridle.enable = hyprland.enable;
  services.hyprsunset.enable = hyprland.enable;

  services.swaync.style = ./swaync.css;
  services.cliphist.systemdTargets = config.wayland.systemd.target;
  # services.hyprsunset.transitions = {
  #   sunrise = {
  #     calendar = "*-*-* 06:00:00";
  #     requests = [
  #       [
  #         "temperature"
  #         "6500"
  #       ]
  #       [ "gamma 100" ]
  #     ];
  #   };
  #   sunset = {
  #     calendar = "*-*-* 19:00:00";
  #     requests = [
  #       [
  #         "temperature"
  #         "3500"
  #       ]
  #     ];
  #   };
  # };

  home.pointerCursor.hyprcursor.enable = hyprland.enable;

  home.file.".profile".enable = hyprland.enable;

  home.file.".profile".text = ''
    if [[ "$(tty)" = "/dev/tty1" ]]; then
    	printf "Do you want to start Hyprland? (Y/n): "
    	read -rn 1 answer
        echo
        if [[ "$answer" = "Y" ]] && ${pkgs.uwsm}/bin/uwsm check may-start; then
            exec ${pkgs.uwsm}/bin/uwsm start ${hyprlandDestkop}
        fi
    fi
  '';

  xdg.portal.config = {
    common.default = [ "hyprland" ];
    hyprland.default = [ "hyprland" ];
  };

  xdg.configFile."uwsm/env-hyprland".enable = hyprland.enable;

  xdg.configFile."uwsm/env-hyprland".text = with import ./gpu-env.nix; ''
    export GBM_BACKEND=${GBM_BACKEND}
    export __GLX_VENDOR_LIBRARY_NAME=${__GLX_VENDOR_LIBRARY_NAME}
    export LIBVA_DRIVER_NAME=${LIBVA_DRIVER_NAME}
    export AQ_DRM_DEVICES=${lib.concatStringsSep ":" AQ_DRM_DEVICES}

    export ALSA_PLUGIN_DIR=${pkgs.pipewire}/lib/alsa-lib
  '';

  imports = [
    ./config.nix
    ./waybar
    ./hyprlock
    ./hyprpaper.nix
    ./hypridle.nix
  ];
}
