builtins.listToAttrs (
  builtins.map
    (path: {
      name = builtins.baseNameOf path + "Bin";
      value =
        assert builtins.pathExists path;
        builtins.baseNameOf path;
    })
    [
      "/usr/bin/sudo"
      "/usr/bin/mktemp"
      "/usr/bin/pidof"
      "/usr/bin/hyprlock"
      "/usr/bin/hyprctl"
      "/usr/bin/pkill"
      "/usr/bin/chmod"
      "/usr/bin/mkdir"
      "/usr/bin/rm"
      "/usr/bin/gcc"
      "/usr/bin/g++"
      "/usr/bin/python3"
    ]
)
