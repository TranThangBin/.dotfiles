{ config, ... }:
let
  gamesDir = "${config.home.homeDirectory}/Games";
  umuConfigDir = "${gamesDir}/umu/config";
  umuRunBin = "${config.lib.packages.umu-launcher-unwrapped}/bin/umu-run";
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
    icon = ./icons/legacy-launcher.png;
    exec = "${config.lib.scripts.minecraft}";
  };
  xdg.desktopEntries.Karlson = gameEntry // {
    name = "Karlson";
    icon = "${gamesDir}/karlson/Karlson_linux_Data/Resources/UnityPlayer.png";
    exec = "${gamesDir}/karlson/Karlson_linux.x86_64";
  };
  xdg.desktopEntries.Rerun = gameEntry // {
    name = "Rerun";
    icon = "${gamesDir}/rerun/RERUN_linux_Data/Resources/UnityPlayer.png";
    exec = "${gamesDir}/rerun/RERUN_linux.x86_64";
  };
  xdg.desktopEntries.ZenlessZoneZero = gameEntry // {
    name = "Zenless Zone Zero";
    genericName = "zzz";
    icon = ./icons/zzz.png;
    exec = "${umuRunBin} --config ${umuConfigDir}/zzz.toml";
  };
  xdg.desktopEntries.PlantVsZombiesRH = gameEntry // {
    name = "PlantVsZombiesRH";
    genericName = "pvz-fusion";
    icon = ./icons/pvz-fusion.jpg;
    exec = "${umuRunBin} --config ${umuConfigDir}/pvz-2.6.toml";
    actions.V2-3-1 = {
      name = "Version 2.3.1";
      exec = "${umuRunBin} --config ${umuConfigDir}/pvz-2.3.1.toml";
    };
    actions.V2-4-2 = {
      name = "Version 2.4.2";
      exec = "${umuRunBin} --config ${umuConfigDir}/pvz-2.4.2.toml";
    };
    actions.V2-5-1 = {
      name = "Version 2.5.1";
      exec = "${umuRunBin} --config ${umuConfigDir}/pvz-2.5.1.toml";
    };
    actions.V2-6 = {
      name = "Version 2.6";
      exec = "${umuRunBin} --config ${umuConfigDir}/pvz-2.6.toml";
    };
  };

  imports = [
    ./steam.nix
    ./epic-games.nix
  ];
}
