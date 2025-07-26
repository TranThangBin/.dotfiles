{
  common,
  packages,
  legacyLauncher,
}:
{
  configFile = import ./configFile {
    inherit (common) mkMerge dotfilesDir scriptPath;
    inherit (packages) pipewire;
  };
  desktopEntries = import ./desktopEntries {
    inherit legacyLauncher;
    inherit (common) mkMerge gamesDir;
    inherit (packages)
      firefox
      umu-launcher-unwrapped
      toybox
      java
      openal
      ;
  };
}
