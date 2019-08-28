source /etc/profile
# Check for an interactive session
[ -z "$PS1" ] && return

##SSH Agent
eval $(keychain --eval --quiet id_ed25519)

alias ls='ls --color=auto'
alias ll='ls -l'
alias grep='grep -n --color'
alias bc='bc -l'
alias ip='ip --color=auto'
alias 1x='~/1x.sh'
alias xmlvalidator='rxp -s'
alias pdftojpg='convert -units PixelsPerInch -density 150x150 -antialias'
alias dual='xrandr --auto --output LVDS1 --primary --mode 1366x768 --left-of VGA1 --output VGA1 --mode 1280x1024'

export EDITOR=vim
export PAGER=less

export XDG_CONFIG_HOME="/home/cgirard/.config"
export AURDEST=/var/lib/pacaurbuild

archmirrorupdate(){
    cp /etc/pacman.d/mirrorlist /tmp/mirrorlist_`date +%s`
    wget -q  'https://www.archlinux.org/mirrorlist/?country=FR&protocol=http&protocol=https&ip_version=4&use_mirror_status=on' -O - | sed 's!^#!!' > /tmp/mirrorlist.new
    echo 'Server=https://archive.archlinux.org/packages/.all' >> /tmp/mirrorlist.new
    sudo cp /tmp/mirrorlist.new /etc/pacman.d/mirrorlist
    sudo pacman -Syy
}

#alias ssh='TERM=rxvt ssh'

svnlog(){
    svn log -v -r {`date -d "$1 days ago" +%F`}:HEAD
}

svncommiterstats(){
    svn  log | perl -MData::Dumper -n -e'if (/^r\d+\s*\|\s*(\w+)\s*\|/) {$c{$1}++} END {print Dumper \%c}'
}

export ARCH_HASKELL='Cedric Girard <girard.cedric@gmail.com>'

deploy_terminfo(){
    if [[ -n $1 ]] ; then
        cat /usr/share/terminfo/x/xterm-termite | ssh $1 "mkdir -p .terminfo/x/ ; cat > .terminfo/x/xterm-termite" \
            && echo "Terminfo deployed to $1"
    fi
}

eval $(dircolors ~/.dircolors)

#export PATH=$PATH:/home/cgirard/.gem/ruby/1.9.1/bin
#export GEM_HOME="~/.gem/ruby/1.9.1"
eval "$(rbenv init -)"

#export PYTHONPATH=/usr/lib/python3.3/site-packages
if [[ $TERM == xterm-termite ]]; then
    . /etc/profile.d/vte.sh
    #PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'__vte_osc7'
    powerline-daemon -q
    export POWERLINE_BASH_CONTINUATION=1
    export POWERLINE_BASH_SELECT=1
    source /usr/lib/python3.7/site-packages/powerline/bindings/bash/powerline.sh
fi

#Bash history
export HISTSIZE=5000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

#local perl libs
perl_local_perl5lib(){
    unset PERL5LIB
    for dir in `find . -type d -name lib` ; do
        PERL5LIB=${PERL5LIB:+$PERL5LIB:}$dir
    done
    export PERL5LIB
}

#tmuxinator
source /usr/lib/ruby/gems/*/gems/tmuxinator-*/completion/tmuxinator.bash

#fzf
source /usr/share/fzf/completion.bash

#the-fuck
eval $(thefuck --alias)

export MOZ_USE_OMTC=1
export MOZ_ENABLE_WAYLAND=1
export SPICE_NOGRAB=1
export QT_QPA_PLATFORM=wayland-egl
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export _JAVA_AWT_WM_NONREPARENTING=1
