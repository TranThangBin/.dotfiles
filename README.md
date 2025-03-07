# .dotfiles

## Installation

### Clone the repos
```bash
git clone git@github:TranThangBin/.dotfiles $HOME/.dotfiles
```

### Install nix (if you don't already have)
```bash
curl -L https://nixos.org/nix/install | sh -s -- --daemon
```

### Also home-manager
```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

### And nixGL
```bash
nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl && nix-channel --update
nix-env -iA nixgl.auto.nixGLDefault
```

### You are ready
```bash
rm -rf $HOME/.config/home-manager # if the default home-manager config already there
ln -sf $HOME/.dotfiles/home-manager $HOME/.config/home-manager
home-manager switch
```

> [!NOTE]
> `hyprland` and `hyprlock` is managed by your prefered package manager.
> [Rootless mode](https://docs.docker.com/engine/security/rootless) for `docker` service.
