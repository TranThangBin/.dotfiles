{ config, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{
  xdg.desktopEntries.LegacyLauncher = {
    type = "Application";
    name = "Legacy Launcher";
    genericName = "Minecraft";
    categories = [ "Game" ];
    prefersNonDefaultGPU = true;
    icon = ./desktop-icons/legacy-launcher.png;
    exec = "${/usr/bin/env} __GL_THREADED_OPTIMIZATIONS=0 LIBGL_ALWAYS_SOFTWARE=1 ${config.programs.java.package}/bin/java -jar ${
      pkgsUnstable.fetchurl {
        url = "https://llaun.ch/jar";
        hash = "sha256-3y0lFukFzch6aOxFb4gWZKWxWLqBCTQlHXtwp0BnlYg=";
      }
    }";
  };
  xdg.desktopEntries.Karlson = {
    type = "Application";
    name = "Karlson";
    categories = [ "Game" ];
    prefersNonDefaultGPU = true;
    icon = "${config.home.homeDirectory}/Games/karlson/Karlson_linux_Data/Resources/UnityPlayer.png";
    exec = "${config.home.homeDirectory}/Games/karlson/Karlson_linux.x86_64";
  };
  xdg.desktopEntries.Rerun = {
    type = "Application";
    name = "Rerun";
    categories = [ "Game" ];
    prefersNonDefaultGPU = true;
    icon = "${config.home.homeDirectory}/Games/rerun/RERUN_linux_Data/Resources/UnityPlayer.png";
    exec = "${config.home.homeDirectory}/Games/rerun/RERUN_linux.x86_64";
  };
  xdg.desktopEntries.ZenlessZoneZero = {
    type = "Application";
    name = "Zenless Zone Zero";
    genericName = "zzz";
    categories = [ "Game" ];
    prefersNonDefaultGPU = true;
    icon = ./desktop-icons/zzz.png;
    exec = "${pkgsUnstable.umu-launcher-unwrapped}/bin/umu-run --config ${config.home.homeDirectory}/Games/umu/config/zzz.toml";
  };
  xdg.desktopEntries.PlantVsZombiesRH = {
    type = "Application";
    name = "PlantVsZombiesRH";
    genericName = "pvz-fusion";
    categories = [ "Game" ];
    prefersNonDefaultGPU = true;
    icon = ./desktop-icons/pvz-fusion.jpg;
    exec = "${pkgsUnstable.umu-launcher-unwrapped}/bin/umu-run --config ${config.home.homeDirectory}/Games/umu/config/pvz-2.5.1.toml";
    actions.V2-3-1 = {
      name = "Version 2.3.1";
      exec = "${pkgsUnstable.umu-launcher-unwrapped}/bin/umu-run --config ${config.home.homeDirectory}/Games/umu/config/pvz-2.3.1.toml";
    };
    actions.V2-4-2 = {
      name = "Version 2.4.2";
      exec = "${pkgsUnstable.umu-launcher-unwrapped}/bin/umu-run --config ${config.home.homeDirectory}/Games/umu/config/pvz-2.4.2.toml";
    };
    actions.V2-5-1 = {
      name = "Version 2.5.1";
      exec = "${pkgsUnstable.umu-launcher-unwrapped}/bin/umu-run --config ${config.home.homeDirectory}/Games/umu/config/pvz-2.5.1.toml";
    };
  };
}
