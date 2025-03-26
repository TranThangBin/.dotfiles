{ pkgs, ... }:
{
  xdg.desktopEntries.LegacyLauncher = {
    type = "Application";
    name = "Legacy Launcher";
    genericName = "Minecraft";
    prefersNonDefaultGPU = true;
    exec = "${pkgs.jdk}/bin/java -jar ${
      pkgs.fetchurl {
        url = "https://llaun.ch/jar";
        hash = "sha256-3y0lFukFzch6aOxFb4gWZKWxWLqBCTQlHXtwp0BnlYg=";
      }
    }";
  };
}
