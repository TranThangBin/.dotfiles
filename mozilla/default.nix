{ config, ... }:
let
  firefoxEntry = {
    type = "Application";
    genericName = "Web Browser";
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
  };
in
{
  imports = [
    ./firefox.nix
    ./thunderbird.nix
  ];

  xdg.desktopEntries.Messenger = firefoxEntry // {
    name = "Messenger";
    icon = "${./icons/Facebook_Messenger_logo_2018.svg}";
    exec = "${config.programs.firefox.finalPackage}/bin/firefox --new-window messenger.com";
  };

  xdg.desktopEntries.Zalo = firefoxEntry // {
    name = "Zalo";
    icon = "${./icons/Icon_of_Zalo.svg}";
    exec = "${config.programs.firefox.finalPackage}/bin/firefox --new-window chat.zalo.me";
  };

  xdg.desktopEntries.Youtube = firefoxEntry // {
    name = "Youtube";
    icon = "${./icons/YouTube_full-color_icon_2017.svg}";
    exec = "${config.programs.firefox.finalPackage}/bin/firefox --new-window youtube.com";
  };

  xdg.desktopEntries.ChatGPT = firefoxEntry // {
    name = "ChatGPT";
    icon = "${./icons/ChatGPT-Logo.svg}";
    exec = "${config.programs.firefox.finalPackage}/bin/firefox --new-window chatgpt.com";
  };

  xdg.desktopEntries.Spotify = firefoxEntry // {
    name = "Spotify";
    icon = "${./icons/Spotify_icon.svg}";
    exec = "${config.programs.firefox.finalPackage}/bin/firefox --new-window open.spotify.com";
  };

  xdg.desktopEntries.Socials = firefoxEntry // {
    name = "Socials";
    icon = "${./icons/multiple-users-silhouette.png}";
    exec = "${config.programs.firefox.finalPackage}/bin/firefox --new-tab messenger.com --new-tab chat.zalo.me";
  };
}
