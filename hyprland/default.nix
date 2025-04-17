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

  programs.wofi.style = "@import url(\"${./wofi.css}\");";

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
    export QT_QPA_PLATFORM=wayland
  '';

  imports = [
    ./config.nix
    ../waybar
    ../hyprlock
    ../hypridle.nix
  ];
}
