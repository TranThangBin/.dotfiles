let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{
  xdg.desktopEntries.LegacyLauncher = {
    type = "Application";
    name = "Legacy Launcher";
    genericName = "Minecraft";
    prefersNonDefaultGPU = true;
    exec = "${pkgsUnstable.jdk}/bin/java -jar ${
      pkgsUnstable.fetchurl {
        url = "https://llaun.ch/jar";
        hash = "sha256-3y0lFukFzch6aOxFb4gWZKWxWLqBCTQlHXtwp0BnlYg=";
      }
    }";
  };
}
