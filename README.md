# .dotfiles

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

For follow up rebuild you only need to use `home-manager switch` since I have alias the target file part

> [!NOTE]
>
> `hyprland` and `hyprlock` should be managed by your native package manager. Also just want to throw `hyprpolkitagent` as a reminder.
> Use `uwsm` with systemd-boot
