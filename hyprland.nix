{ common, packages }:
{
  settings = with packages; {
    "$terminal" = "${hyprlandExtra.uwsm}/bin/uwsm-app ${ghostty}/bin/ghostty";
    "$resourceMonitor" = "${hyprlandExtra.uwsm}/bin/uwsm-app ${btop}/share/applications/btop.desktop";
    "$fileExplorer" = "${hyprlandExtra.uwsm}/bin/uwsm-app ${yazi}/share/applications/yazi.desktop";
    "$logoutMenu" = "${wlogout}/bin/wlogout";
    "$colorPicker" = "${hyprlandExtra.hyprpicker}/bin/hyprpicker";
    "$emojiPicker" = "${hyprlandExtra.wofi-emoji}/bin/wofi-emoji";
    "$screenshotCMD" = "${hyprlandExtra.hyprshot}/bin/hyprshot";
    "$screenshotRegion" = "$screenshotCMD -m region";
    "$screenshotWindow" = "$screenshotCMD -m window";
    "$screenshotOutput" = "$screenshotCMD -m output";
    "$clipboardScreenshotRegion" = "$screenshotCMD -m region --clipboard-only";
    "$clipboardScreenshotWindow" = "$screenshotCMD -m window --clipboard-only";
    "$clipboardScreenshotOutput" = "$screenshotCMD -m output --clipboard-only";
    "$toggleStatusBar" = "${toybox}/bin/pkill -SIGUSR1 waybar";
    "$swayosdClientBin" = "${swayosd}/bin/swayosd-client";
    "$launcher" = "$SCRIPT_DIR/wofi-uwsm-wrapped.sh";
    "$clipboardPicker" = "$SCRIPT_DIR/clipboard-picker.sh";
    "$clipboardDelete" = "$SCRIPT_DIR/clipboard-delete.sh";
    "$clipboardWipe" = "$SCRIPT_DIR/clipboard-wipe.sh";
    "$kittyBackgroundOpacity" = toString common.kittyBackgroundOpacity;
    "$ghosttyBackgroundOpacity" = toString common.ghosttyBackgroundOpacity;

    source = [
      "${./hypr/hyprcat.conf}"
      "${./hypr/hyprcommon.conf}"
      "${./hypr/hyprland.conf}"
    ];
  };
}
