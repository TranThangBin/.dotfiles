{
  config,
  lib,
  pkgs,
  ...
}:
let
  hyprlandEnabled = config.wayland.windowManager.hyprland.enable;
  gpuEnv = "/dev/dri/card2:/dev/dri/card1";
in
{
  programs.hyprlock.enable = hyprlandEnabled;
  programs.waybar.enable = hyprlandEnabled;
  programs.wofi.enable = hyprlandEnabled;
  programs.wlogout.enable = hyprlandEnabled;
  services.swaync.enable = hyprlandEnabled;

  services.hyprpaper.enable = hyprlandEnabled;
  services.hypridle.enable = hyprlandEnabled;

  xdg.configFile."uwsm/env-hyprland".enable = hyprlandEnabled;

  home.file.".profile".enable = hyprlandEnabled;

  xdg.portal.configPackages = lib.optionals hyprlandEnabled [
    pkgs.xdg-desktop-portal-hyprland
  ];
  xdg.configFile."uwsm/env-hyprland".text = "export AQ_DRM_DEVICES=${gpuEnv}";

  home.packages = lib.optionals hyprlandEnabled [
    pkgs.uwsm
    pkgs.hyprshot
    pkgs.kdePackages.dolphin
    pkgs.kdePackages.qt6ct
  ];

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
