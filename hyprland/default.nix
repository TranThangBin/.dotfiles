{ config, lib, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
let
  gpuEnv = "/dev/dri/card2:/dev/dri/card1";
in
with config.wayland.windowManager;
{
  wayland.windowManager.hyprland.portalPackage = pkgsUnstable.xdg-desktop-portal-hyprland;

  programs.hyprlock.enable = hyprland.enable;
  programs.waybar.enable = hyprland.enable;
  programs.wofi.enable = hyprland.enable;
  programs.wlogout.enable = hyprland.enable;

  programs.hyprlock.package = pkgsUnstable.emptyDirectory; # Manage hyprlock with your os package manager
  programs.waybar.package = pkgsUnstable.waybar;
  programs.wofi.package = pkgsUnstable.wofi;
  programs.wlogout.package = pkgsUnstable.wlogout;

  services.swaync.enable = hyprland.enable;
  services.hyprpaper.enable = hyprland.enable;
  services.hypridle.enable = hyprland.enable;

  services.swaync.package = pkgsUnstable.swaynotificationcenter;
  services.hyprpaper.package = pkgsUnstable.hyprpaper;
  services.hypridle.package = pkgsUnstable.hypridle;

  xdg.configFile."uwsm/env-hyprland".enable = hyprland.enable;

  home.file.".profile".enable = hyprland.enable;

  xdg.portal.configPackages = lib.optionals hyprland.enable [
    pkgsUnstable.xdg-desktop-portal-hyprland
    pkgsUnstable.xdg-desktop-portal-wlr
  ];

  home.packages = lib.optionals hyprland.enable [
    pkgsUnstable.uwsm
    pkgsUnstable.hyprshot
    pkgsUnstable.kdePackages.dolphin
  ];

  xdg.configFile."uwsm/env-hyprland".text = "export AQ_DRM_DEVICES=${gpuEnv}";

  home.file.".profile".text = with pkgsUnstable; ''
    if [[ "$(tty)" = "/dev/tty1" ]]; then
        ${fastfetch}/bin/fastfetch
    	printf "Do you want to start Hyprland? (Y/n): "
    	read -rn 1 answer
        echo
        if [[ "$answer" = "Y" ]] && ${uwsm}/bin/uwsm check may-start; then
            exec ${uwsm}/bin/uwsm start /usr/share/wayland-sessions/hyprland.desktop
        fi
    fi
  '';

  imports = [
    ./config.nix
    ../hyprlock
    ../waybar
    ../wofi
    ../hyprpaper
    ../hypridle.nix
  ];
}
