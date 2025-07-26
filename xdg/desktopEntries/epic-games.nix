{ gamesDir, umuRun }:
let
  gameEntry = {
    type = "Application";
    categories = [ "Game" ];
    prefersNonDefaultGPU = true;
  };
in
{
  EpicGamesStore = gameEntry // {
    name = "Epic Games Launcher";
    icon = "${gamesDir}/epic-games-store/drive_c/Program Files (x86)/Epic Games/Launcher/Portal/SysFiles/default_toast_epic_logo_white.png";
    exec =
      (umuRun {
        store = "egs";
        winePrefix = "${gamesDir}/epic-games-store";
        exe = "${gamesDir}/epic-games-store/drive_c/Program Files (x86)/Epic Games/Launcher/Portal/Binaries/Win32/EpicGamesLauncher.exe";
      })
      + "-opengl -SkipBuildPatchPrereq";
  };
}
