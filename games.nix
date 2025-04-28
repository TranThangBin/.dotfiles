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
    icon = "${pkgsUnstable.fetchurl {
      url = "https://llaun.ch/apple-touch-icon.png";
      hash = "sha256-5h3smXfHufVIdCned0XZmswPAHwls4ybNkgyunH6QYk=";
    }}";
    exec = "${pkgsUnstable.jdk}/bin/java -jar ${
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
    icon = "${config.home.homeDirectory}/Games/karlson/Karlson_linux_Data/Resources/Unity/UnityPlayer.png";
    exec = "${config.home.homeDirectory}/Games/karlson/Karlson_linux.x86_64";
  };
  xdg.desktopEntries.ZenlessZoneZero = {
    type = "Application";
    name = "Zenless Zone Zero";
    genericName = "zzz";
    categories = [ "Game" ];
    prefersNonDefaultGPU = true;
    icon = "${pkgsUnstable.fetchurl {
      url = "https://zenless.hoyoverse.com/favicon.ico";
      hash = "sha256-jiSZr7O/9kfrFmLsi+fxtrpBwosa+hy07mF1SSiDtsI=";
    }}";
    exec = "${pkgsUnstable.umu-launcher-unwrapped}/bin/umu-run --config ${config.home.homeDirectory}/Games/umu/config/zzz.toml";
  };
  xdg.desktopEntries.PlantVsZombiesRH = {
    type = "Application";
    name = "PlantVsZombiesRH";
    genericName = "pvz-fusion";
    categories = [ "Game" ];
    prefersNonDefaultGPU = true;
    icon = "${pkgsUnstable.fetchurl {
      url = "https://superhybrid.online/wp-content/uploads/2024/08/04213ae95667ef39b676-150x150.jpg";
      hash = "sha256-q1/Kg3bsJgN37/rZB+np8KaaV0v2pd+u5ZQ6PIGy0As=";
    }}";
    exec = "${pkgsUnstable.umu-launcher-unwrapped}/bin/umu-run --config ${config.home.homeDirectory}/Games/umu/config/pvz-2.4.2.toml";
    actions.V2-3-1 = {
      name = "Version 2.3.1";
      exec = "${pkgsUnstable.umu-launcher-unwrapped}/bin/umu-run --config ${config.home.homeDirectory}/Games/umu/config/pvz-2.3.1.toml";
    };
    actions.V2-4-2 = {
      name = "Version 2.4.2";
      exec = "${pkgsUnstable.umu-launcher-unwrapped}/bin/umu-run --config ${config.home.homeDirectory}/Games/umu/config/pvz-2.4.2.toml";
    };
  };
}
