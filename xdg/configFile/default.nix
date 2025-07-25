{ mkMerge, pipewire }:
mkMerge [
  { nvim.source = "${./nvim}"; }
  (import ./systemd-override.nix)
  (import ./uwsm.nix { inherit pipewire; })
  (import ./hyprcommon.nix)
]
