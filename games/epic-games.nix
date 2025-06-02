{ config, pkgs, ... }:
let
  umu-launcher = pkgs.umu-launcher-unwrapped;
  gamesDir = "${config.home.homeDirectory}/Games";
  umuConfigDir = "${gamesDir}/umu/config";
  gameEntry = {
    type = "Application";
    categories = [ "Game" ];
    prefersNonDefaultGPU = true;
  };
in
{
  xdg.desktopEntries.EpicGamesStore = gameEntry // {
    name = "Epic Games Launcher";
    icon = ../desktop-icons/Epic_Games_logo.svg;
    exec = "${umu-launcher}/bin/umu-run --config ${umuConfigDir}/egs.toml";
  };
}
