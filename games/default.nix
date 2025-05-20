{
  config,
  pkgs,
  legacyLauncher,
  ...
}:
let
  umu-launcher = pkgs.umu-launcher-unwrapped;
  gamesDirectory = "${config.home.homeDirectory}/Games";
  umuConfigDirectory = "${gamesDirectory}/umu/config";
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
    icon = ../desktop-icons/legacy-launcher.png;
    exec = "${pkgs.toybox}/bin/env __GL_THREADED_OPTIMIZATIONS=0 LIBGL_ALWAYS_SOFTWARE=1 ${pkgs.alsa-oss}/bin/aoss ${config.programs.java.package}/bin/java -jar ${legacyLauncher}";
  };
  xdg.desktopEntries.Karlson = gameEntry // {
    name = "Karlson";
    icon = "${gamesDirectory}/karlson/Karlson_linux_Data/Resources/UnityPlayer.png";
    exec = "${gamesDirectory}/karlson/Karlson_linux.x86_64";
  };
  xdg.desktopEntries.Rerun = gameEntry // {
    name = "Rerun";
    icon = "${gamesDirectory}/rerun/RERUN_linux_Data/Resources/UnityPlayer.png";
    exec = "${gamesDirectory}/rerun/RERUN_linux.x86_64";
  };
  xdg.desktopEntries.ZenlessZoneZero = gameEntry // {
    name = "Zenless Zone Zero";
    genericName = "zzz";
    icon = ../desktop-icons/zzz.png;
    exec = "${umu-launcher}/bin/umu-run --config ${umuConfigDirectory}/zzz.toml";
  };
  xdg.desktopEntries.PlantVsZombiesRH = gameEntry // {
    name = "PlantVsZombiesRH";
    genericName = "pvz-fusion";
    icon = ../desktop-icons/pvz-fusion.jpg;
    exec = "${umu-launcher}/bin/umu-run --config ${umuConfigDirectory}/pvz-2.5.1.toml";
    actions.V2-3-1 = {
      name = "Version 2.3.1";
      exec = "${umu-launcher}/bin/umu-run --config ${umuConfigDirectory}/pvz-2.3.1.toml";
    };
    actions.V2-4-2 = {
      name = "Version 2.4.2";
      exec = "${umu-launcher}/bin/umu-run --config ${umuConfigDirectory}/pvz-2.4.2.toml";
    };
    actions.V2-5-1 = {
      name = "Version 2.5.1";
      exec = "${umu-launcher}/bin/umu-run --config ${umuConfigDirectory}/pvz-2.5.1.toml";
    };
  };
}
