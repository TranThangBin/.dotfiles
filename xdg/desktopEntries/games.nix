{
  gamesDir,
  minecraftScript,
  umuConfigDir,
  umu-launcher-unwrapped,
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
    exec = "${minecraftScript}";
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
  ZenlessZoneZero = gameEntry // {
    name = "Zenless Zone Zero";
    genericName = "zzz";
    icon = ./desktop-icons/zzz.png;
    exec = "${umu-launcher-unwrapped}/bin/umu-run --config ${umuConfigDir}/zzz.toml";
  };
  PlantVsZombiesRH = gameEntry // {
    name = "PlantVsZombiesRH";
    genericName = "pvz-fusion";
    icon = ./desktop-icons/pvz-fusion.jpg;
    exec = "${umu-launcher-unwrapped}/bin/umu-run --config ${umuConfigDir}/pvz-2.6.toml";
    actions.V2-3-1 = {
      name = "Version 2.3.1";
      exec = "${umu-launcher-unwrapped}/bin/umu-run --config ${umuConfigDir}/pvz-2.3.1.toml";
    };
    actions.V2-4-2 = {
      name = "Version 2.4.2";
      exec = "${umu-launcher-unwrapped}/bin/umu-run --config ${umuConfigDir}/pvz-2.4.2.toml";
    };
    actions.V2-5-1 = {
      name = "Version 2.5.1";
      exec = "${umu-launcher-unwrapped}/bin/umu-run --config ${umuConfigDir}/pvz-2.5.1.toml";
    };
    actions.V2-6 = {
      name = "Version 2.6";
      exec = "${umu-launcher-unwrapped}/bin/umu-run --config ${umuConfigDir}/pvz-2.6.toml";
    };
  };
}
