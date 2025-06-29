{
  config,
  pkgs,
  legacyLauncher,
  ...
}:
let
  wofi = config.programs.wofi;
  cliphist = config.services.cliphist;
in
{
  lib.scripts = {
    minecraft = pkgs.writeShellScript "minecraft.sh" ''
      export __GL_THREADED_OPTIMIZATIONS=0
      export LD_PRELOAD=${pkgs.openal}/lib/libopenal.so.1
      ${config.programs.java.package}/bin/java -jar ${legacyLauncher}
    '';

    wofiUwsmWrapped = pkgs.writeShellScript "wofi-uwsm-wrapped.sh" ''
      app=$( ${wofi.package}/bin/wofi --show drun --define=drun-print_desktop_file=true )
      if [[ "$app" == *'desktop '* ]]; then
         ${pkgs.uwsm}/bin/uwsm-app "''${app%.desktop *}.desktop:''${app#*.desktop }"
      elif [[ "$app" == *'desktop' ]]; then
         ${pkgs.uwsm}/bin/uwsm-app "$app"
      fi
    '';

    clipboardPicker = pkgs.writeShellScript "clipboard-picker" ''
      ${cliphist.package}/bin/cliphist list |
          ${wofi.package}/bin/wofi -S dmenu -p 'Clipboard pick:' |
          ${cliphist.package}/bin/cliphist decode |
          ${pkgs.wl-clipboard}/bin/wl-copy
    '';

    clipboardDelete = pkgs.writeShellScript "clipboard-delete.sh" ''
      ${cliphist.package}/bin/cliphist list |
          ${wofi.package}/bin/wofi -S dmenu -p 'Clipboard delete:' |
          ${cliphist.package}/bin/cliphist delete
    '';

    clipboardWipe = pkgs.writeShellScript "clipboard-wipe.sh" ''
      confirm=$( echo -e "no\nyes" | ${wofi.package}/bin/wofi -S dmenu -p 'Do you want to wipe the clipboard?' )
      if [[ $confirm = "yes" ]]; then
          ${cliphist.package}/bin/cliphist wipe
      fi
    '';
  };

  home.file = builtins.listToAttrs (
    builtins.map (
      scriptName:
      let
        source = config.lib.scripts.${scriptName};
      in
      {
        name = ".local/bin/${source.name}";
        value.source = source;
      }
    ) (builtins.attrNames config.lib.scripts)
  );
}
