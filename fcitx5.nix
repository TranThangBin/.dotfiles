let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{
  i18n.inputMethod.fcitx5.ignoreUserConfig = true;
  i18n.inputMethod.fcitx5.themes.Tokyonight-Storm.theme =
    "${pkgsUnstable.fcitx5-tokyonight}/share/fcitx5/themes/Tokyonight-Storm/theme.conf";
  i18n.inputMethod.fcitx5.settings.inputMethod = {
    GroupOrder."0" = "Default";
    "Groups/0" = {
      Name = "Default";
      "Default Layout" = "us";
      DefaultIM = "unikey";
    };
    "Groups/0/Items/0".Name = "keyboard-us";
    "Groups/0/Items/1".Name = "unikey";
  };
  i18n.inputMethod.fcitx5.settings.globalOptions = {
    Hotkey = {
      EnumerateWithTriggerKeys = true;
    };
    "Hotkey/TriggerKeys"."0" = "Control+Shift+space";
  };
  i18n.inputMethod.fcitx5.settings.addons = {
    clipboard.sections.TriggerKey."0" = "Super+V";
    clipboard.globalSection = {
      "Number of entries" = 5;
      IgnorePasswordFromPasswordManager = false;
      ShowPassword = false;
      ClearPasswordAfter = 30;
    };
    classicui.globalSection = {
      Font = "Noto Sans 12";
      MenuFont = "Noto Sans 12";
      TrayFont = "Noto Sans 12";
      Theme = "Tokyonight-Storm";
      DarkTheme = "Tokyonight-Storm";
    };
  };
}
