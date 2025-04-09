{ config, lib, ... }:
{
  imports = [ ./config.nix ];

  xdg.desktopEntries.FirefoxSocials = {
    type = "Application";
    name = "Firefox (Socials)";
    prefersNonDefaultGPU = true;
    exec = lib.concatStringsSep " " [
      "${config.programs.firefox.package}/bin/firefox"
      "--new-window"
      "messenger.com"
      "chat.zalo.me"
      "web.telegram.org"
      "youtube.com"
    ];
  };
}
