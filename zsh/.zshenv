# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export EDITOR="/usr/bin/nvim"

export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

PATH="/home/trant/perl5/bin${PATH:+:${PATH}}"
export PATH
PERL5LIB="/home/trant/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL5LIB
PERL_LOCAL_LIB_ROOT="/home/trant/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_LOCAL_LIB_ROOT
PERL_MB_OPT="--install_base \"/home/trant/perl5\""
export PERL_MB_OPT
PERL_MM_OPT="INSTALL_BASE=/home/trant/perl5"
export PERL_MM_OPT

[ -f $HOME/.cargo/env ] && . "$HOME/.cargo/env"

type go &>/dev/null && export PATH="$PATH:$(go env GOPATH)/bin"

export GTK_IM_MODULE="wayland"
export QT_IM_MODULE="wayland;fcitx;ibus"
export SDL_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"
export INPUT_METHOD="fcitx"
export GLFW_IM_MODULE="ibus"
