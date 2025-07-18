{
  mkMerge,
  podman,
  waylandSystemdTarget,
  xdg-desktop-portal,
  xdg-desktop-portal-hyprland,
  xdg-desktop-portal-termfilechooser,
  mpvpaper,
  preferedVideopaper,
  pipewire,
  wireplumber,
}:
{
  user = mkMerge [
    (import ./podman.nix { inherit podman; })
    (import ./mpvpaper.nix { inherit waylandSystemdTarget mpvpaper preferedVideopaper; })
    (import ./pipewire.nix { inherit pipewire wireplumber; })
    (import ./xdg-desktop-portal.nix {
      inherit
        waylandSystemdTarget
        xdg-desktop-portal
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-termfilechooser
        ;
    })
  ];
}
