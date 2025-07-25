{
  packages,
  binaries,
  legacyLauncher,
}:
with packages;
{
  "minecraft.sh" = [
    "${openal}/lib/libopenal.so.1"
    "${java}/bin/java"
    "${legacyLauncher}"
  ];
  "wofi-uwsm-wrapped.sh" = [
    "${wofi}/bin/wofi"
    "${uwsm}/bin/uwsm-app"
  ];
  "clipboard-picker.sh" = [
    "${cliphist}/bin/cliphist"
    "${wofi}/bin/wofi"
    "${wl-clipboard}/bin/wl-copy"
  ];
  "clipboard-delete.sh" = [
    "${cliphist}/bin/cliphist"
    "${wofi}/bin/wofi"
  ];
  "clipboard-wipe.sh" = [
    "${wofi}/bin/wofi"
    "${cliphist}/bin/cliphist"
  ];
  "unitynvim.sh" = [
    "${neovim}/bin/nvim"
    "${neovide}/bin/neovide"
  ];
  "godotnvim.sh" = [
    "${neovim}/bin/nvim"
    "${neovide}/bin/neovide"
  ];
  "mount-smb.sh" = with binaries; [
    mktempBin
    chmodBin
    sudoBin
    mkdirBin
    "${cifs-utils}/bin/mount.cifs"
    rmBin
  ];
  "code-run.sh" = with binaries; [
    mktempBin
    gccBin
    (binaries."g++Bin")
    "${go}/bin/go"
    python3Bin
    rmBin
  ];
}
