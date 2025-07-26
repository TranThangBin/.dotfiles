{
  gamesDir,
  umuRun,
  runWithEnv,
  java,
  openal,
  legacyLauncher,
}:
let
  gameEntry = {
    type = "Application";
    categories = [ "Game" ];
    prefersNonDefaultGPU = true;
  };
in
{
  LegacyLauncher = gameEntry // {
    name = "Legacy Launcher";
    genericName = "Minecraft";
    icon = ./desktop-icons/legacy-launcher.png;
    exec =
      (runWithEnv [
        "__GL_THREADED_OPTIMIZATIONS=0"
        "LD_PRELOAD=${openal}/lib/libopenal.so.1"
      ])
      + " ${java}/bin/java -jar ${legacyLauncher}";
  };
  Karlson = gameEntry // {
    name = "Karlson";
    icon = "${gamesDir}/karlson/Karlson_linux_Data/Resources/UnityPlayer.png";
    exec = "${gamesDir}/karlson/Karlson_linux.x86_64";
  };
  Rerun = gameEntry // {
    name = "Rerun";
    icon = "${gamesDir}/rerun/RERUN_linux_Data/Resources/UnityPlayer.png";
    exec = "${gamesDir}/rerun/RERUN_linux.x86_64";
  };
  HoYoPlay = gameEntry // {
    name = "HoYoPlay";
    icon = "";
    genericName = "HoYo";
    exec = umuRun {
      winePrefix = "${gamesDir}/MiHoYo";
      exe = "${gamesDir}/MiHoYo/drive_c/Program Files/HoYoPlay/launcher.exe";
    };
  };
  ZenlessZoneZero = gameEntry // {
    name = "Zenless Zone Zero";
    genericName = "zzz";
    icon = "${gamesDir}/MiHoYo/drive_c/Program Files/HoYoPlay/1.8.0.264/ico/nap_global.ico";
    exec = umuRun {
      gameID = "umu-zenlesszonezero";
      winePrefix = "${gamesDir}/MiHoYo";
      exe = "${gamesDir}/MiHoYo/drive_c/Program Files/HoYoPlay/games/ZenlessZoneZero Game/ZenlessZoneZero.exe";
    };
  };
  PlantVsZombiesRH =
    gameEntry
    // (
      let
        latest = builtins.elemAt pvzFusionCollection 0;
        pvzFusionCollection = [
          "2.6"
          "2.5.1"
          "2.4.2"
          "2.3.1"
        ];
      in
      {
        name = "PlantVsZombiesRH";
        genericName = "pvz-fusion";
        icon = ./desktop-icons/pvz-fusion.jpg;
        exec = "${gamesDir}/etc/pvz-fusion/pvz-fusion-${latest}/PlantsVsZombiesRH.exe";
        actions = builtins.listToAttrs (
          builtins.map (ver: {
            name = "V" + builtins.replaceStrings [ "." ] [ "-" ] ver;
            value = {
              name = ver;
              exec = umuRun {
                winePrefix = "${gamesDir}/pvz-fusion";
                exe = "${gamesDir}/etc/pvz-fusion/pvz-fusion-${ver}/PlantsVsZombiesRH.exe";
              };
            };
          }) pvzFusionCollection
        );
      }
    );
}
