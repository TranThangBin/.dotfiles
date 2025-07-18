{ config, lib, ... }:
let
  hyprland = config.wayland.windowManager.hyprland;
in
{
  wayland.systemd.target = "wayland-session@hyprland.desktop.target";

  i18n.inputMethod.fcitx5.waylandFrontend = hyprland.enable;

  home.pointerCursor.hyprcursor.enable = hyprland.enable;

  xdg.portal.config = {
    common.default = [ "hyprland" ];
    hyprland.default = [ "hyprland" ];
  };

  xdg.configFile."uwsm/env".enable = hyprland.enable;
  xdg.configFile."uwsm/env-hyprland".enable = hyprland.enable;

  xdg.configFile."uwsm/env".text = ''
    export ALSA_PLUGIN_DIR=${config.lib.packages.pipewire}/lib/alsa-lib
    export ELECTRON_OZONE_PLATFORM_HINT=wayland
  '';
  xdg.configFile."uwsm/env-hyprland".text = with import ./gpu-env.nix; ''
    export GBM_BACKEND=${GBM_BACKEND}
    export __GLX_VENDOR_LIBRARY_NAME=${__GLX_VENDOR_LIBRARY_NAME}
    export LIBVA_DRIVER_NAME=${LIBVA_DRIVER_NAME}
    export AQ_DRM_DEVICES=${lib.concatStringsSep ":" AQ_DRM_DEVICES}
  '';

  imports = [ ./config.nix ];
}
