# sourced on new screens, non-login shells.
# echo sourcing .bashrc
host=`uname -n | sed -e 's/\.local//g'`;
my_uname=`uname`;

# rm -f /tmp/bashstart.*.log
# PS4='+ $(date "+%s.%N")\011 '
# exec 3>&2 2>/tmp/bashstart.$$.log
# set -x

if [ "$my_uname" == "Darwin" ]; then
    [[ -s "/opt/boxen/env.sh" ]] && source "/opt/boxen/env.sh"

    brewery=`brew --prefix`
    [[ -s $brewery/etc/profile.d/autojump.sh ]] && . $brewery/etc/profile.d/autojump.sh
    [[ -s $brewery/etc/bash_completion ]] && . $brewery/etc/bash_completion
    [ -f /Users/norton/.travis/travis.sh ] && source /Users/norton/.travis/travis.sh

    export EDITNOW='subl'
    export EDITOR='subl -w'
    export LESS="$LESS -i -F -R -X"

    # give the VM a semi-ridiculous amount of memory.
    LOTS_O_MEM='-Xmx1024m -Xms256m -XX:MaxPermSize=128m'
    # make JVM GC sweep permgen as well.
    GC_PERMGEN='-XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC'
    DO_DUMPS='-XX:+HeapDumpOnOutOfMemoryError'
    NO_DOCK_ICON="-Djava.awt.headless=true"

    [[ "`which gfind`" ]] && alias find="gfind"
    [[ "`which gsleep`" ]] && alias sleep="gsleep"
    [[ "`which aws`" ]] && complete -C aws_completer aws
    # [[ "`which jenv`" ]] || export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

    export GRADLE_OPTS="$LOTS_O_MEM $GC_PERMGEN $NO_DOCK_ICON $DO_DUMP"
    export JAVA_OPTS="$LOTS_O_MEM $GC_PERMGEN $NO_DOCK_ICON $DO_DUMPS"
    export CATALINA_OPTS="$LOTS_O_MEM $GC_PERMGEN $DO_DUMPS"

    export GOPATH=$HOME/go

    # preview man
    pman() {
        man -t "${1}" | open -f -a /Applications/Preview.app/
    }

    alias jj='autojump'
    # use BSD ls with no --color
    alias ls="/bin/ls -F"
    alias top='top -o cpu'
    alias opena="open -n -a"
    alias crontab="EDITOR=vi VIM_CRONTAB=true crontab"

    function gradle(){
        if [[ -f ./gradlew ]]; then
            (echo ./gradlew $@ 2>&1; ./gradlew $@)
        else
            (echo $(which gradle) $@ 2>&1; $(which gradle) $@)
        fi
    }

    function kali(){
        if ! VBoxManage list runningvms | grep kali; then
            nohup VBoxHeadless --startvm kali --vrde off >/dev/null 2>&1 &
        fi
        ssh -Y -p31339 root@127.0.0.1
    }

elif [ "$my_uname" == "Linux" ]; then

    # use GNU ls with --color
    alias ls='ls --color -F'
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

    export EDITNOW='vim'
    export EDITOR='vim'

    [[ -s /usr/share/autojump/autojump.sh ]] && . /usr/share/autojump/autojump.sh
    [[ -s ~/.bash_aliases ]] && . ~/.bash_aliases;
    if [[ -s /etc/bash_completion ]] && ! shopt -oq posix; then
        . /etc/bash_completion;
    fi
fi

export CLICOLOR=1
export TERM=xterm-color
export HISTIGNORE="[   ]*:&:bg:fg:exit"
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
export HISTTIMEFORMAT="%d/%m/%y %T "     # timestamps in history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# do close spelling matches with cd
shopt -s cdspell
shopt -s nocaseglob
shopt -s checkwinsize

# handy aliases
alias ll='ls -l'
alias la='ls -hlA'
alias l='ls'
alias rm='rm -v'
alias df='df -h'
alias du='du -h'
alias grep="grep --color"
alias hist="history|tail"
alias history="history|tail -n100"
alias psa="ps auxwww"

alias hosts='sudo $EDITNOW /etc/hosts'

# fun aliases
alias wtc='curl -s "http://whatthecommit.com" | grep "<p>" | cut -c4-'

alias hex32="LC_CTYPE=C tr -dc 'A-F0-9' < /dev/urandom | fold -w 32 | head -n1"
alias prpg="LC_CTYPE=C tr -dc 'A-Za-z0-9_-' < /dev/urandom | fold -w 16 | head -n1"

alias nukelock="find -maxdepth 2 -name Gemfile.lock | xargs git checkout"

#aliases for my local stuff
alias ddate="date '+%Y%m%d%'"
alias mdate="date '+%Y-%m-%d%'"
alias cdate="date '+%Y%m%d%H%M%S'"

note(){
    atom /Users/norton/Dropbox\ \(Betterment\)/Notes/$(cdate).md
}

rpg(){
    size=${1:-12}; ruby -e "require 'securerandom'; puts SecureRandom.urlsafe_base64($size);"
}

git-rm-banch(){
    git branch -D $1 && git push origin :$1
}

parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

basher(){
    env -i PATH=$PATH HOME=$HOME TERM=xterm-color "$(command -v bash)" --noprofile --norc
}

uninstall-all-rbenv-gems-for-current-ruby-version() {
  list=`gem list --no-versions`
  for gem in $list; do
    gem uninstall $gem -aIx
  done
  gem list
  gem install bundler
}

uber_prompt() {
    local        BLUE="\[\033[0;34m\]"
    local      YELLOW="\[\033[0;33m\]"
    local         RED="\[\033[0;31m\]"
    local   LIGHT_RED="\[\033[1;31m\]"
    local       GREEN="\[\033[0;32m\]"
    local LIGHT_GREEN="\[\033[1;32m\]"
    local       WHITE="\[\033[1;37m\]"
    local  LIGHT_GRAY="\[\033[0;37m\]"
    PS1="$LIGHT_GRAY$*$GREEN\$(parse_git_branch)$LIGHT_GRAY\$ "
    PS2='> '
    PS4='+ '
}

figcom () {
    figlet "$@" | sed 's/^/# /g'
}

myself="`whoami`"
linux_prompt="[\u@\h \W]"
darwin_prompt="\u@\h:\W"
me_prompt="\h:\W"

if [ "$uname" == "Darwin" ]; then
    if [ "$myself" == 'yuriy' -o "$myself" == 'ygoldman' ]; then
        uber_prompt $me_prompt;
    else
        uber_prompt $darwin_prompt;
    fi
else
    uber_prompt $linux_prompt
fi

# if there are settings for a particular machine, put them in .local.bashrc
# i.e. PS1="[\u@\h \W]\$ "
[[ -s $HOME/.local.bashrc ]]  && . $HOME/.local.bashrc
[[ -s $HOME/.local/.bashrc ]] && . $HOME/.local/.bashrc
[[ -s $HOME/.local.passwordrc ]]  && . $HOME/.local.passwordrc

[[ -s "$HOME/.bootstrap/env.sh" ]] && . "$HOME/.bootstrap/env.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [[ ":$PATH:" != *":$HOME/.datacoral/cli/bin:"* ]];
then
  export PATH=$HOME/.datacoral/cli/bin:$PATH
fi
