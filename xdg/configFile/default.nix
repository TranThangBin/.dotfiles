{
  mkMerge,
  pipewire,
  dotfilesDir,
  scriptPath,
}:
mkMerge [
  { nvim.source = "${./nvim}"; }
  (import ./systemd-override.nix)
  (import ./uwsm.nix { inherit pipewire dotfilesDir scriptPath; })
]
