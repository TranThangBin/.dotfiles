{
  config,
  lib,
  pkgs,
  ...
}:
let
  gpuEnv = "/dev/dri/card2:/dev/dri/card1";
in
with config.wayland.windowManager;
{
  programs.hyprlock.enable = hyprland.enable;
  programs.waybar.enable = hyprland.enable;
  programs.wofi.enable = hyprland.enable;
  programs.wlogout.enable = hyprland.enable;
  services.swaync.enable = hyprland.enable;

  services.hyprpaper.enable = hyprland.enable;
  services.hypridle.enable = hyprland.enable;

  xdg.configFile."uwsm/env-hyprland".enable = hyprland.enable;

  home.file.".profile".enable = hyprland.enable;

  xdg.portal.configPackages = lib.optionals hyprland.enable [
    pkgs.xdg-desktop-portal-hyprland
  ];

  home.packages = lib.optionals hyprland.enable [
    pkgs.uwsm
    pkgs.hyprshot
    pkgs.kdePackages.dolphin
    pkgs.kdePackages.qt6ct
  ];

  xdg.configFile."uwsm/env-hyprland".text = "export AQ_DRM_DEVICES=${gpuEnv}";

  home.file.".profile".text = with pkgs; ''
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
