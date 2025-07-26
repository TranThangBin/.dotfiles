{
  pipewire,
  dotfilesDir,
  scriptPath,
}:
let
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  LIBVA_DRIVER_NAME = "nvidia";
  AQ_DRM_DEVICES = [
    "/dev/dri/card2"
    "/dev/dri/card1"
    "/dev/dri/card0"
  ];
in
{
  "uwsm/env".text = ''
    export ALSA_PLUGIN_DIR=${pipewire}/lib/alsa-lib
    export ELECTRON_OZONE_PLATFORM_HINT=wayland
    export DOTFILES_DIR=${dotfilesDir}
    export SCRIPT_DIR=${scriptPath}
  '';
  "uwsm/env-hyprland".text = ''
    export GBM_BACKEND=${GBM_BACKEND}
    export __GLX_VENDOR_LIBRARY_NAME=${__GLX_VENDOR_LIBRARY_NAME}
    export LIBVA_DRIVER_NAME=${LIBVA_DRIVER_NAME}
    export AQ_DRM_DEVICES=${builtins.concatStringsSep ":" AQ_DRM_DEVICES}
  '';
}
