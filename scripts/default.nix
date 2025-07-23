{
  config,
  legacyLauncher,
  pkgs,
  ...
}:
let
  wofi = config.programs.wofi;
  cliphist = config.services.cliphist;
in
{
  lib.scripts = {
    minecraftScript = pkgs.writeShellScript "minecraft.sh" ''
      export __GL_THREADED_OPTIMIZATIONS=0
      export LD_PRELOAD=$LD_PRELOAD:${pkgs.openal}/lib/libopenal.so.1
      ${config.programs.java.package}/bin/java -jar ${legacyLauncher}
    '';

    wofiScript = pkgs.writeShellScript "wofi-uwsm-wrapped.sh" ''
      app=$( ${wofi.package}/bin/wofi --show drun --define=drun-print_desktop_file=true )
      if [[ "$app" == *'desktop '* ]]; then
         ${pkgs.uwsm}/bin/uwsm-app "''${app%.desktop *}.desktop:''${app#*.desktop }"
      elif [[ "$app" == *'desktop' ]]; then
         ${pkgs.uwsm}/bin/uwsm-app "$app"
      fi
    '';

    clipboardPickerScript = pkgs.writeShellScript "clipboard-picker" ''
      ${cliphist.package}/bin/cliphist list |
          ${wofi.package}/bin/wofi -S dmenu -p 'Clipboard pick:' |
          ${cliphist.package}/bin/cliphist decode |
          ${pkgs.wl-clipboard}/bin/wl-copy
    '';

    clipboardDeleteScript = pkgs.writeShellScript "clipboard-delete.sh" ''
      ${cliphist.package}/bin/cliphist list |
          ${wofi.package}/bin/wofi -S dmenu -p 'Clipboard delete:' |
          ${cliphist.package}/bin/cliphist delete
    '';

    clipboardWipeScript = pkgs.writeShellScript "clipboard-wipe.sh" ''
      confirm=$( echo -e "no\nyes" | ${wofi.package}/bin/wofi -S dmenu -p 'Do you want to wipe the clipboard?' )
      if [[ $confirm = "yes" ]]; then
          ${cliphist.package}/bin/cliphist wipe
      fi
    '';
  };
}
