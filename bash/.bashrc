source /etc/profile
# Check for an interactive session
[ -z "$PS1" ] && return

alias ls='ls --color=auto'
alias ll='ls -l'
alias grep='grep -n --color'
alias bc='bc -l'
alias 1x='~/1x.sh'
alias xmlvalidator='rxp -s'
alias pdftojpg='convert -units PixelsPerInch -density 150x150 -antialias'
alias dual='xrandr --auto --output LVDS1 --primary --mode 1366x768 --left-of VGA1 --output VGA1 --mode 1280x1024'
alias pacaur='proxychains4 -q pacaur'

export EDITOR=vim
export PAGER=less

export ARCH_HASKELL='Cedric Girard <girard.cedric@gmail.com>'
export XDG_CONFIG_HOME="/home/cgirard/.config"

archmirrorupdate(){
    cp /etc/pacman.d/mirrorlist /tmp/mirrorlist_`date +%s`
    wget -q  'https://www.archlinux.org/mirrorlist/?country=FR&protocol=http&protocol=https&ip_version=4&use_mirror_status=on' -O - | sed 's!^#!!' > /tmp/mirrorlist.new
    echo 'Server=http://seblu.net/a/arm/all' >> /tmp/mirrorlist.new
    sudo cp /tmp/mirrorlist.new /etc/pacman.d/mirrorlist
    sudo pacman -Syy
}


svnlog(){
    svn log -v -r {`date -d "$1 days ago" +%F`}:HEAD
}

svncommiterstats(){
    svn  log | perl -MData::Dumper -n -e'if (/^r\d+\s*\|\s*(\w+)\s*\|/) {$c{$1}++} END {print Dumper \%c}'
}


deploy_terminfo(){
    if [[ -n $1 ]] ; then
        cat /usr/share/terminfo/x/xterm-termite | ssh $1 "mkdir -p .terminfo/x/ ; cat > .terminfo/x/xterm-termite" \
            && echo "Terminfo deployed to $1"
    fi
}

eval $(dircolors ~/.dircolors)
if [[ $TERM == xterm-termite ]]; then
    . /etc/profile.d/vte.sh
    #PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'__vte_osc7'
    source /usr/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
fi

#Bash history
export HISTSIZE=5000
export HISTCONTROL=ignoredups
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
