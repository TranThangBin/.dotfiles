{ config, pkgs, ... }:
let
  gameEntry = {
    type = "Application";
    categories = [ "Game" ];
    prefersNonDefaultGPU = true;
  };
in
{
  xdg.desktopEntries.LegacyLauncher = gameEntry // {
    name = "Legacy Launcher";
    genericName = "Minecraft";
    icon = ./desktop-icons/legacy-launcher.png;
    exec = "${/usr/bin/env} __GL_THREADED_OPTIMIZATIONS=0 LIBGL_ALWAYS_SOFTWARE=1 ${config.programs.java.package}/bin/java -jar ${
      pkgs.fetchurl {
        url = "https://llaun.ch/jar";
        hash = "sha256-3y0lFukFzch6aOxFb4gWZKWxWLqBCTQlHXtwp0BnlYg=";
      }
    }";
  };
  xdg.desktopEntries.Karlson = gameEntry // {
    name = "Karlson";
    icon = "${config.home.homeDirectory}/Games/karlson/Karlson_linux_Data/Resources/UnityPlayer.png";
    exec = "${config.home.homeDirectory}/Games/karlson/Karlson_linux.x86_64";
  };
  xdg.desktopEntries.Rerun = gameEntry // {
    name = "Rerun";
    icon = "${config.home.homeDirectory}/Games/rerun/RERUN_linux_Data/Resources/UnityPlayer.png";
    exec = "${config.home.homeDirectory}/Games/rerun/RERUN_linux.x86_64";
  };
  xdg.desktopEntries.ZenlessZoneZero = gameEntry // {
    name = "Zenless Zone Zero";
    genericName = "zzz";
    icon = ./desktop-icons/zzz.png;
    exec = "${pkgs.umu-launcher-unwrapped}/bin/umu-run --config ${config.home.homeDirectory}/Games/umu/config/zzz.toml";
  };
  xdg.desktopEntries.PlantVsZombiesRH = gameEntry // {
    name = "PlantVsZombiesRH";
    genericName = "pvz-fusion";
    icon = ./desktop-icons/pvz-fusion.jpg;
    exec = "${pkgs.umu-launcher-unwrapped}/bin/umu-run --config ${config.home.homeDirectory}/Games/umu/config/pvz-2.5.1.toml";
    actions.V2-3-1 = {
      name = "Version 2.3.1";
      exec = "${pkgs.umu-launcher-unwrapped}/bin/umu-run --config ${config.home.homeDirectory}/Games/umu/config/pvz-2.3.1.toml";
    };
    actions.V2-4-2 = {
      name = "Version 2.4.2";
      exec = "${pkgs.umu-launcher-unwrapped}/bin/umu-run --config ${config.home.homeDirectory}/Games/umu/config/pvz-2.4.2.toml";
    };
    actions.V2-5-1 = {
      name = "Version 2.5.1";
      exec = "${pkgs.umu-launcher-unwrapped}/bin/umu-run --config ${config.home.homeDirectory}/Games/umu/config/pvz-2.5.1.toml";
    };
  };
}
