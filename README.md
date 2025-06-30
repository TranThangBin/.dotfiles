# .dotfiles

![Desktop screenshot of the configuration](./images/desktop-screenshot.png)

## Prerequisite

### Require

- `hyprland`
- `hyprlock`

### Optional

- `NetworkManager`
- `cups`
- `blueman`
- `ufw`
- `sbctl`
- `tuned-ppd`
- `hyprpolkitagent`

## Installation

### Clone the repos

```bash
git clone git@github:TranThangBin/.dotfiles $HOME/.dotfiles
cd $HOME/.dotfiles
```

### Install nix (if you don't already have)

```bash
curl -L https://nixos.org/nix/install | sh -s -- --daemon
```

### You are ready

```bash
nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake $HOME/.dotfiles --impure
```

Relaunch your shell and we can use `home-manager --flake $DOTFILES_DIR switch --impure` in future rebuild
