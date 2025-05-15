# .dotfiles

## Installation

### Clone the repos

```bash
git clone git@github:TranThangBin/.dotfiles ~/.dotfiles
cd ~/.dotfiles
```

### Install nix (if you don't already have)

```bash
curl -L https://nixos.org/nix/install | sh -s -- --daemon
```

### Setup home-manager and nixGL

```bash
cp .nix-channels ~/.nix-channels
nix-channel --update
nix-shell '<home-manager>' -A install
```

### You are ready

```bash
home-manager switch -f $HOME/.dotfiles/home.nix
```

For follow up rebuild you only need to use `home-manager switch` since I have alias the target file part

> [!NOTE]
>
> `hyprland` and `hyprlock` should be managed by your native package manager. Also just want to throw `hyprpolkitagent` as a reminder.
> Use `uwsm` with systemd-boot
