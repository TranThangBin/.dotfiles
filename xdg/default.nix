{
  mkMerge,
  firefox,
  gamesDir,
  minecraftScript,
  umuConfigDir,
  umu-launcher-unwrapped,
  pipewire,
}:
{
  configFile = import ./configFile { inherit mkMerge pipewire; };
  desktopEntries = import ./desktopEntries {
    inherit
      mkMerge
      firefox
      gamesDir
      umuConfigDir
      umu-launcher-unwrapped
      minecraftScript
      ;
  };
}
