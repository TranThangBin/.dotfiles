{ config, lib, ... }:
{
  imports = [ ./config.nix ];

  xdg.desktopEntries.FirefoxSocials = {
    type = "Application";
    name = "Firefox (Socials)";
    genericName = "Web Browser";
    icon = "firefox";
    prefersNonDefaultGPU = true;
    startupNotify = true;
    terminal = false;
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
    exec = lib.concatStringsSep " " [
      "${config.programs.firefox.finalPackage}/bin/firefox"
      "--name"
      "firefox"
      "messenger.com"
      "chat.zalo.me"
      "web.telegram.org"
      "youtube.com"
    ];
  };
}
