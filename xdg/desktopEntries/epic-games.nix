{ umu-launcher-unwrapped, umuConfigDir }:
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
    icon = "${./desktop-icons/Epic_Games_logo.svg}";
    exec = "${umu-launcher-unwrapped}/bin/umu-run --config ${umuConfigDir}/egs.toml";
  };
}
