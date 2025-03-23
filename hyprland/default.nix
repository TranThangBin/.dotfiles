{ config, pkgs, ... }:
if !builtins.pathExists "/usr/bin/Hyprland" then
  { }
else
  {
    imports = [
      ./config.nix
      ../hyprpaper
      ../hyprlock.nix
      ../hypridle.nix
      ../waybar
      ../wofi
    ];

    home = {
      packages = with pkgs; [
        hyprshot
        kdePackages.dolphin
        kdePackages.qt6ct
        uwsm
      ];
      file.".profile".text = with pkgs; ''
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
    };

    xdg = {
      portal.configPackages = [ config.wayland.windowManager.hyprland.portalPackage ];
      configFile."uwsm/env-hyprland".text = ''export AQ_DRM_DEVICES="/dev/dri/card2:/dev/dri/card1"'';
    };

    programs.wlogout.enable = true;
    services.swaync.enable = true;
  }
