# .dotfiles

## Prerequisite

### Require

- `hyprland`
- `hyprlock`

### Optional

- `NetworkManager`
- `cups`
- `bluez`
- `ufw`
- `sbctl`
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

Relaunch zsh we can use `home-manager switch --impure` instead. Use `which home-manager` if you are confused
