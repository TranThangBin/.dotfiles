{
  mkMerge,
  firefox,
  gamesDir,
  toybox,
  umu-launcher-unwrapped,
  java,
  openal,
  legacyLauncher,
}:
let
  runWithEnv = envs: "${toybox}/bin/env " + builtins.concatStringsSep " " envs;
  umuRun =
    {
      gameID ? "",
      store ? "",
      winePrefix,
      exe,
    }:
    builtins.concatStringsSep " " [
      (runWithEnv [
        "GAMEID=${gameID}"
        "STORE=${store}"
        "WINEPREFIX=${winePrefix}"
      ])
      "${umu-launcher-unwrapped}/bin/umu-run"
      ''"${exe}"''
    ];
in
mkMerge [
  (import ./steam.nix)
  (import ./firefox.nix { inherit firefox; })
  (import ./epic-games.nix { inherit gamesDir umuRun; })
  (import ./games.nix {
    inherit
      gamesDir
      runWithEnv
      umuRun
      java
      openal
      legacyLauncher
      ;
  })
]
