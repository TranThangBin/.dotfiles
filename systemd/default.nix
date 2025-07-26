{ common, packages }:
{
  user = common.mkMerge [
    (import ./podman.nix { inherit (packages) podman; })
    (import ./mpvpaper.nix {
      inherit (common) waylandSystemdTarget preferedVideopaper;
      inherit (packages) mpvpaper;
    })
    (import ./pipewire.nix { inherit (packages) pipewire wireplumber; })
    (import ./xdg-desktop-portal.nix {
      inherit (common) waylandSystemdTarget;
      inherit (packages)
        xdg-desktop-portal
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-termfilechooser
        ;
    })
  ];
}
