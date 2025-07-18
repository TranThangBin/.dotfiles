{ config, ... }:
let
  hyprland = config.wayland.windowManager.hyprland;
in
{
  wayland.systemd.target = "wayland-session@hyprland.desktop.target";

  i18n.inputMethod.fcitx5.waylandFrontend = hyprland.enable;

  home.pointerCursor.hyprcursor.enable = hyprland.enable;

  imports = [ ./config.nix ];
}
