#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '
if [[ $EUID == 0 ]] ; then
    PS1='\[\033[0;31m\]╔═(\[\033[0m\033[0;31m\]\u\[\033[0m\]@\[\033[0;36m\]\h\[\033[0m\033[0;31m\])────(\[\033[0m\]\t \d\[\033[0;31m\])────(\[\033[0m\]\w\[\033[0;31m\])\n\[\033[0;31m\]╚═══[\[\033[0m\033[0;31m\]\$\[\033[0m\033[0;31m\]]>\[\033[0m\] '
else
    PS1='\[\033[0;32m\]╔═(\[\033[0m\033[0;32m\]\u\[\033[0m\]@\[\033[0;36m\]\h\[\033[0m\033[0;32m\])────(\[\033[0m\]\t \d\[\033[0;32m\])────(\[\033[0m\]\w\[\033[0;32m\])\n\[\033[0;32m\]╚═══[\[\033[0m\033[0;32m\]\$\[\033[0m\033[0;32m\]]>\[\033[0m\] '
fi

PS2='> '
PS3='> '
PS4='+ '

case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
