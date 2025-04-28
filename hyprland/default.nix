{ config, lib, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> { };
  preferedWallpaper = ./wallpapers/go-to-the-moon.png;
in
with config.wayland.windowManager;
{
  programs.hyprlock.enable = hyprland.enable;
  programs.waybar.enable = hyprland.enable;
  programs.wofi.enable = hyprland.enable;
  programs.wlogout.enable = hyprland.enable;

  programs.hyprlock.package = pkgsUnstable.emptyDirectory; # Manage hyprlock with your os package manager
  programs.waybar.package = pkgsUnstable.waybar;
  programs.wofi.package = pkgsUnstable.wofi;
  programs.wlogout.package = pkgsUnstable.wlogout;

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
      action = "${pkgsUnstable.systemd}/bin/loginctl lock-session";
      text = "Lock";
      keybind = "l";
    }
    {
      label = "hibernate";
      action = "${pkgsUnstable.systemd}/bin/systemctl hibernate";
      text = "Hibernate";
      keybind = "h";
    }
    {
      label = "logout";
      action = "${pkgsUnstable.uwsm}/bin/uwsm stop";
      text = "Logout";
      keybind = "e";
    }
    {
      label = "shutdown";
      action = "${pkgsUnstable.systemd}/bin/systemctl poweroff";
      text = "Shutdown";
      keybind = "s";
    }
    {
      label = "suspend";
      action = "${pkgsUnstable.systemd}/bin/systemctl suspend";
      text = "Suspend";
      keybind = "u";
    }
    {
      label = "reboot";
      action = "${pkgsUnstable.systemd}/bin/systemctl reboot";
      text = "Reboot";
      keybind = "r";
    }
  ];

  services.swaync.enable = hyprland.enable;
  services.hyprpaper.enable = hyprland.enable;
  services.hypridle.enable = hyprland.enable;

  services.swaync.package = pkgsUnstable.swaynotificationcenter;
  services.hyprpaper.package = pkgsUnstable.hyprpaper;
  services.hypridle.package = pkgsUnstable.hypridle;

  services.swaync.style = ./swaync.css;
  services.hyprpaper.settings = {
    preload = "${preferedWallpaper}";
    wallpaper = ",${preferedWallpaper}";
    ipc = "off";
  };

  home.pointerCursor.hyprcursor.enable = hyprland.enable;

  home.file.".profile".enable = hyprland.enable;

  home.file.".profile".source = pkgsUnstable.writeShellScript ".profile" ''
    #! /usr/bin/env bash

    if [[ "$(tty)" = "/dev/tty1" ]]; then
    	printf "Do you want to start Hyprland? (Y/n): "
    	read -rn 1 answer
        echo
        if [[ "$answer" = "Y" ]] && ${pkgsUnstable.uwsm}/bin/uwsm check may-start; then
            exec ${pkgsUnstable.uwsm}/bin/uwsm start ${/usr/share/wayland-sessions/hyprland.desktop}
        fi
    fi
  '';

  xdg.portal.config.hyprland.default = [ "hyprland" ];

  xdg.configFile."uwsm/env-hyprland".enable = hyprland.enable;

  xdg.configFile."uwsm/env-hyprland".text = with import ./gpu-env.nix; ''
    export AQ_DRM_DEVICES=${lib.concatStringsSep ":" AQ_DRM_DEVICES}
    export GBM_BACKEND=${GBM_BACKEND}
    export __GLX_VENDOR_LIBRARY_NAME=${__GLX_VENDOR_LIBRARY_NAME}
    export LIBVA_DRIVER_NAME=${LIBVA_DRIVER_NAME}
    export ALSA_PLUGIN_DIR=${pkgsUnstable.pipewire}/lib/alsa-lib
  '';

  imports = [
    ./config.nix
    ../waybar
    ../hyprlock
    ../hypridle.nix
  ];
}
