# .dotfiles

## Prerequisites
- stow
- gcc
- fd
- rg


## Installation
```bash
git clone git@github:TranThangBin/.dotfiles $HOME/.dotfiles
```

## Setup Guide
**cd to the .dotfiles directory**
```bash
cd $HOME/.dotfiles
```

### Oh My Zsh
```bash
git clone https://github.com/ohmyzsh/ohmyzsh.git $HOME/.dotfiles/zsh/.oh-my-zsh
```

### zsh-autosuggestions
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
    $HOME/.dotfiles/zsh/.oh-my-zsh/custom/plugins/zsh-autosuggestions
```
### F-Sy-H
```bash
git clone https://github.com/z-shell/F-Sy-H.git \
    $HOME/.dotfiles/zsh/.oh-my-zsh/custom/plugins/F-Sy-H
```

### .tmux
```bash
git clone https://github.com/gpakosz/.tmux.git $HOME/.dotfiles/tmux/.tmux
ln -sf tmux/.tmux/.tmux.conf tmux/.tmux.conf
```
