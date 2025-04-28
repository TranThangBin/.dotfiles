{ config, ... }:
{
  imports = [ ./config.nix ];

  xdg.desktopEntries.FirefoxCustom = {
    type = "Application";
    name = "Firefox Custom";
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
    exec = "${config.programs.firefox.finalPackage}/bin/firefox --name firefox-custom";
    actions.Socials = {
      name = "Socials";
      exec = "${config.programs.firefox.finalPackage}/bin/firefox --name firefox-custom --new-tab messenger.com --new-tab chat.zalo.me";
    };
    actions.Messenger = {
      name = "Messenger";
      exec = "${config.programs.firefox.finalPackage}/bin/firefox --name firefox-custom --new-tab messenger.com";
    };
    actions.Zalo = {
      name = "Zalo";
      exec = "${config.programs.firefox.finalPackage}/bin/firefox --name firefox-custom --new-tab chat.zalo.me";
    };
    actions.Youtube = {
      name = "Youtube";
      exec = "${config.programs.firefox.finalPackage}/bin/firefox --name firefox-custom --new-tab youtube.com";
    };
  };
}
