{
  mkMerge,
  firefox,
  gamesDir,
  minecraft,
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
      minecraft
      umuConfigDir
      umu-launcher-unwrapped
      ;
  };
}
