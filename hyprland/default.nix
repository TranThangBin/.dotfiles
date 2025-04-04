{ config, lib, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> { };
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

  services.swaync.enable = hyprland.enable;
  services.hyprpaper.enable = hyprland.enable;
  services.hypridle.enable = hyprland.enable;

  services.swaync.package = pkgsUnstable.swaynotificationcenter;
  services.hyprpaper.package = pkgsUnstable.hyprpaper;
  services.hypridle.package = pkgsUnstable.hypridle;

  xdg.configFile."uwsm/env-hyprland".enable = hyprland.enable;

  home.file.".profile".enable = hyprland.enable;

  xdg.portal.configPackages = lib.optionals hyprland.enable [ hyprland.portalPackage ];

  home.packages = lib.optionals hyprland.enable [
    pkgsUnstable.uwsm
    pkgsUnstable.hyprshot
    pkgsUnstable.kdePackages.dolphin
  ];

  xdg.configFile."uwsm/env-hyprland".text = ''
    export AQ_DRM_DEVICES=${(import ./gpu-env.nix).AQ_DRM_DEVICES}
  '';

  home.file.".profile".source = pkgsUnstable.writeShellScript ".profile" ''
    if [[ "$(tty)" = "/dev/tty1" ]]; then
        ${pkgsUnstable.fastfetch}/bin/fastfetch
    	printf "Do you want to start Hyprland? (Y/n): "
    	read -rn 1 answer
        echo
        if [[ "$answer" = "Y" ]] && ${pkgsUnstable.uwsm}/bin/uwsm check may-start; then
            exec ${pkgsUnstable.uwsm}/bin/uwsm start /usr/share/wayland-sessions/hyprland.desktop
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
