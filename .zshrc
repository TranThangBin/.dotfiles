# Created by newuser for 5.9

if [ -f ~/.env ]; then
	. ~/.env
fi

set -o vi

case $- in
*i*) ;;
*) return ;;
esac

HISTCONTROL=ignoreboth

setopt APPEND_HISTORY

HISTSIZE=1000
HISTFILESIZE=2000

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='%F{green}%n@%m%f:%F{blue}%~%f$ '
else
	PS1='%n@%m:%~$ '
fi
unset color_prompt force_color_prompt

case "$TERM" in
xterm* | rxvt*)
	PS1="%{%e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~%a%}$PS1"
	;;
*) ;;
esac

# zoxide
_z_cd() {
	cd "$@" || return "$?"

	if [ "$_ZO_ECHO" = "1" ]; then
		echo "$PWD"
	fi
}

z() {
	if [ "$#" -eq 0 ]; then
		_z_cd ~
	elif [ "$#" -eq 1 ] && [ "$1" = '-' ]; then
		if [ -n "$OLDPWD" ]; then
			_z_cd "$OLDPWD"
		else
			echo 'zoxide: $OLDPWD is not set'
			return 1
		fi
	else
		_zoxide_result="$(zoxide query -- "$@")" && _z_cd "$_zoxide_result"
	fi
}

zi() {
	_zoxide_result="$(zoxide query -i -- "$@")" && _z_cd "$_zoxide_result"
}

zcl() {
	rm ~/.local/share/zoxide/db.zo
}

zri() {
	_zoxide_result="$(zoxide query -i -- "$@")" && zoxide remove "$_zoxide_result"
}

_zoxide_hook() {
	if [ -z "${_ZO_PWD}" ]; then
		_ZO_PWD="${PWD}"
	elif [ "${_ZO_PWD}" != "${PWD}" ]; then
		_ZO_PWD="${PWD}"
		zoxide add "$(pwd -L)"
	fi
}

case "$PROMPT_COMMAND" in
*_zoxide_hook*) ;;
*) PROMPT_COMMAND="_zoxide_hook${PROMPT_COMMAND:+;${PROMPT_COMMAND}}" ;;
esac
# zoxide end

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/robbyrussell.omp.json)"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

eval "$(fzf --zsh)"

fzfd() {
	if [ -z "$1" ]; then
		fd . . -t d | fzf --preview='ls {}'
	else
		fd . $1 -t d | fzf --preview='ls {}'
	fi
}

if [ -f ~/.aliases ]; then
	. ~/.aliases
fi
