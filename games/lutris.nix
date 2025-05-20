# { config, pkgs, ... }:
# let
#   wineWow64PackagesFull = pkgs.wineWow64Packages.full;
# in
{
  # programs.lutris.package = config.lib.nixGL.wrapOffload pkgs.lutris;
  #
  # programs.lutris.protonPackages = [ pkgs.proton-ge-bin ];
  #
  # programs.lutris.steamPackage = pkgs.steam;
  #
  # programs.lutris.winePackages = [ wineWow64PackagesFull ];
  #
  # programs.lutris.runners = {
  #   steam.settings.runner.runner_executable = "${config.programs.lutris.steamPackage}/bin/steam";
  #   wine.settings.runner.runner_executable = "${wineWow64PackagesFull}/bin/wine";
  # };
}
