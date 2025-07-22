{ fcitx5-unikey, fcitx5-tokyonight }:
{
  addons = [
    fcitx5-unikey
    fcitx5-tokyonight
  ];
  themes.Tokyonight-Storm.theme = "${fcitx5-tokyonight}/share/fcitx5/themes/Tokyonight-Storm/theme.conf";
  settings.inputMethod = {
    GroupOrder."0" = "Default";
    "Groups/0" = {
      Name = "Default";
      "Default Layout" = "us";
      DefaultIM = "unikey";
    };
    "Groups/0/Items/0".Name = "keyboard-us";
    "Groups/0/Items/1".Name = "unikey";
  };
  settings.globalOptions = {
    Hotkey = {
      EnumerateWithTriggerKeys = true;
      AltTriggerKeys = "";
      EnumerateForwardKeys = "";
      EnumerateBackwardKeys = "";

    };
    "Hotkey/TriggerKeys"."0" = "Control+Shift+space";
    "Hotkey/AltTriggerKeys"."0" = "";
  };
  settings.addons = {
    clipboard.sections.TriggerKey = { };
    classicui.globalSection = {
      Font = "Noto Sans 12";
      MenuFont = "Noto Sans 12";
      TrayFont = "Noto Sans 12";
      Theme = "Tokyonight-Storm";
      DarkTheme = "Tokyonight-Storm";
    };
  };
}
