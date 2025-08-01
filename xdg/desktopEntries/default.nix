{
  mkMerge,
  firefox,
  gamesDir,
  minecraftScript,
  umuConfigDir,
  umu-launcher-unwrapped,
}:
mkMerge [
  (import ./steam.nix)
  (import ./firefox.nix { inherit firefox; })
  (import ./epic-games.nix { inherit umu-launcher-unwrapped umuConfigDir; })
  (import ./games.nix {
    inherit
      gamesDir
      umuConfigDir
      umu-launcher-unwrapped
      minecraftScript
      ;
  })
]
