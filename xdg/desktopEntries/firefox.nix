{ firefox }:
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
  Messenger = firefoxEntry // {
    name = "Messenger";
    icon = "${./desktop-icons/Facebook_Messenger_logo_2018.svg}";
    exec = "${firefox}/bin/firefox --new-window messenger.com";
  };

  Zalo = firefoxEntry // {
    name = "Zalo";
    icon = "${./desktop-icons/Icon_of_Zalo.svg}";
    exec = "${firefox}/bin/firefox --new-window chat.zalo.me";
  };

  Youtube = firefoxEntry // {
    name = "Youtube";
    icon = "${./desktop-icons/YouTube_full-color_icon_2017.svg}";
    exec = "${firefox}/bin/firefox --new-window youtube.com";
  };

  ChatGPT = firefoxEntry // {
    name = "ChatGPT";
    icon = "${./desktop-icons/ChatGPT-Logo.svg}";
    exec = "${firefox}/bin/firefox --new-window chatgpt.com";
  };

  Spotify = firefoxEntry // {
    name = "Spotify";
    icon = "${./desktop-icons/Spotify_icon.svg}";
    exec = "${firefox}/bin/firefox --new-window open.spotify.com";
  };

  Socials = firefoxEntry // {
    name = "Socials";
    icon = "${./desktop-icons/multiple-users-silhouette.png}";
    exec = "${firefox}/bin/firefox --new-tab messenger.com --new-tab chat.zalo.me";
  };
}
