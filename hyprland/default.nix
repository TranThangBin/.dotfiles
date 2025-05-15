{
  config,
  lib,
  pkgs,
  ...
}:
with config.wayland.windowManager;
{
  wayland.systemd.target = "wayland-session@hyprland.desktop.target";

  programs.hyprlock.enable = hyprland.enable;
  programs.waybar.enable = hyprland.enable;
  programs.wofi.enable = hyprland.enable;
  programs.wlogout.enable = hyprland.enable;

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
      action = "${pkgs.systemd}/bin/loginctl lock-session";
      text = "Lock";
      keybind = "l";
    }
    {
      label = "hibernate";
      action = "${config.systemd.user.systemctlPath} hibernate";
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
      action = "${config.systemd.user.systemctlPath} poweroff";
      text = "Shutdown";
      keybind = "s";
    }
    {
      label = "suspend";
      action = "${config.systemd.user.systemctlPath} suspend";
      text = "Suspend";
      keybind = "u";
    }
    {
      label = "reboot";
      action = "${config.systemd.user.systemctlPath} reboot";
      text = "Reboot";
      keybind = "r";
    }
  ];

  services.swaync.enable = hyprland.enable;
  services.hyprpaper.enable = hyprland.enable;
  services.hypridle.enable = hyprland.enable;
  services.network-manager-applet.enable = hyprland.enable;
  services.hyprsunset.enable = hyprland.enable;

  services.swaync.style = ./swaync.css;
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

  home.file.".profile".source = pkgs.writeShellScript ".profile" ''
    if [[ "$(tty)" = "/dev/tty1" ]]; then
    	printf "Do you want to start Hyprland? (Y/n): "
    	read -rn 1 answer
        echo
        if [[ "$answer" = "Y" ]] && ${pkgs.uwsm}/bin/uwsm check may-start; then
            exec ${pkgs.uwsm}/bin/uwsm start ${
              assert lib.pathExists "/usr/share/wayland-sessions/hyprland.desktop";
              "hyprland.desktop"
            }
        fi
    fi
  '';

  xdg.portal.config = {
    common.default = [ "hyprland" ];
    hyprland.default = [ "hyprland" ];
  };

  xdg.configFile."uwsm/env-hyprland".enable = hyprland.enable;

  xdg.configFile."uwsm/env-hyprland".text = with import ./gpu-env.nix; ''
    export AQ_DRM_DEVICES=${lib.concatStringsSep ":" AQ_DRM_DEVICES}
    export GBM_BACKEND=${GBM_BACKEND}
    export __GLX_VENDOR_LIBRARY_NAME=${__GLX_VENDOR_LIBRARY_NAME}
    export LIBVA_DRIVER_NAME=${LIBVA_DRIVER_NAME}
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
