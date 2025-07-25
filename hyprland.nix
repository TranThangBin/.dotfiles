{
  uwsm,
  ghostty,
  btop,
  yazi,
  wofiScript,
  wlogout,
  hyprpicker,
  wofi-emoji,
  clipboardPickerScript,
  clipboardDeleteScript,
  clipboardWipeScript,
  hyprshot,
  swayosd,
  kittyBackgroundOpacity,
  ghosttyBackgroundOpacity,
  pkillBin,
}:
{
  settings = {
    "$uwsmAppBin" = "${uwsm}/bin/uwsm-app";
    "$ghosttyBin" = "${ghostty}/bin/ghostty";
    "$btopDesktop" = "${btop}/share/applications/btop.desktop";
    "$yaziDesktop" = "${yazi}/share/applications/yazi.desktop";
    "$wofiScript" = wofiScript;
    "$wlogoutBin" = "${wlogout}/bin/wlogout";
    "$hyprpickerBin" = "${hyprpicker}/bin/hyprpicker";
    "$wofiEmojiBin" = "${wofi-emoji}/bin/wofi-emoji";
    "$clipboardPickerScript" = clipboardPickerScript;
    "$clipboardDeleteScript" = clipboardDeleteScript;
    "$clipboardWipeScript" = clipboardWipeScript;
    "$hyprshotBin" = "${hyprshot}/bin/hyprshot";
    "$pkillBin" = pkillBin;
    "$swayosdClientBin" = "${swayosd}/bin/swayosd-client";

    source = [
      "${./hypr/hyprcat.conf}"
      "${./hypr/hyprcommon.conf}"
      "${./hypr/hyprland.conf}"
    ];
  };
}
