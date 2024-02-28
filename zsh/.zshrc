# local settings(pre loading)
for i in "${ZDOTDIR}"/pre_rc/*.zsh(N) ; do
    source "${i}"
done

autoload -Uz compinit add-zsh-hook vcs_info
compinit

setopt AUTO_CD

unsetopt AUTO_REMOVE_SLASH
setopt COMPLETE_IN_WORD
setopt GLOB_COMPLETE
setopt MENU_COMPLETE

setopt GLOB_DOTS
setopt MARK_DIRS

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_NO_FUNCTIONS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY

unsetopt CLOBBER
setopt CORRECT
setopt IGNORE_EOF
setopt INTERACTIVE_COMMENTS
setopt PRINT_EXIT_VALUE

setopt APPEND_CREATE

setopt COMBINING_CHARS

export PS1="%F{blue}%M%f:%F{yellow}%c%f%(!.:%K{white}%F{red}#%f%k.) "

export WORDCHARS="!#$%^~\\@+-=_*?"

export HISTFILE="${ZDOTDIR}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

export EDITOR="vim"
export VISUAL="vim"
export MANPAGER="vim -M +MANPAGER -"

export LESS="-i -R --no-histdups"
export LESSHISTFILE="/dev/null"

export GPG_TTY="$(tty)"

if test -r "${XDG_CONFIG_HOME}/.dir_colors" && command -v dircolors >| "/dev/null" 2>&1 ; then
    eval $(dircolors "${XDG_CONFIG_HOME}/.dir_colors")
else
    export LS_COLORS="di=34:ln=35:so=36:pi=32:ex=31:bd=30;46:cd=30;44:su=37;41:sg=30;41:tw=30;45:ow=30;43:st=30;42:"
fi

if ls --color=auto >| "/dev/null" 2>&1 ; then # GNU ls
    alias ls="ls -A -F --color=auto"
elif ls -G >| "/dev/null" 2>&1 ; then         # BSD ls
    alias ls="ls -A -F -G"
    export LSCOLORS="exfxgxcxbxagaehbabafad"
else
    alias ls="ls -A -F"
fi

alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# similar smartcase
zstyle ":completion:*" matcher-list "m:{[:lower:]}={[:upper:]}"

zstyle ":completion:*" ignore-parents "parent" "pwd"
zstyle ":completion:*" squeeze-slashes "true"

zstyle ":completion:*" menu "select"
zstyle ":completion:*" force-list "always"
zstyle ":completion:*:default" list-colors "${LS_COLORS}"

zstyle ":completion:*" group-name ""
zstyle ":completion:*:descriptions" format "%F{green}-- %d --%f"
zstyle ":completion:*:messages" format "%F{yellow}%d%f"
zstyle ":completion:*:warnings" format "%F{red}no matches%f"

# "_man" completer
zstyle ":completion:*:manuals" separate-sections "true"
zstyle ":completion:*:manuals.*" insert-sections "true"

# vcs
zstyle ":vcs_info:*" check-for-changes "true"
zstyle ":vcs_info:*" stagedstr "[%F{yellow}S%f]"
zstyle ":vcs_info:*" unstagedstr "[%F{red}U%f]"
zstyle ":vcs_info:*" formats "%%F{magenta}%b%%f@%%F{blue}%r%%f%c%u"

my_precmd_setrprompt()
{
    vcs_info
    # branch@repo[staged][unstaged]
    RPS1="${vcs_info_msg_0_}"
}
add-zsh-hook -Uz precmd my_precmd_setrprompt

my_chpwd_autols()
{
    ls
}
add-zsh-hook -Uz chpwd my_chpwd_autols

# footのspawn-terminalを動作させるのに必要
# <https://codeberg.org/dnkl/foot/wiki#user-content-spawning-new-terminal-instances-in-the-current-working-directory>
if [[ "${TERM}" =~ "foot" ]] ; then
    function osc7-pwd() {
        emulate -L zsh # also sets localoptions for us
        setopt extendedglob
        local LC_ALL=C
        printf '\e]7;file://%s%s\e\' "${HOST}" "${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}"
    }

    function chpwd-osc7-pwd() {
        (( ZSH_SUBSHELL )) || osc7-pwd
    }
    add-zsh-hook -Uz chpwd chpwd-osc7-pwd
fi

# OSC 2 ; Pt BEL (change window title to Pt)
# <https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Operating-System-Commands>
if [[ "${TERM}" =~ "xterm|konsole|alacritty|tmux|screen|st|foot" ]] ; then
    my_precmd_setwindowtitle()
    {
        # set window title to PWD
        print -n -P "\033]2;%~\007"
    }
    add-zsh-hook -Uz precmd my_precmd_setwindowtitle

    my_preexec_setwindowtitle()
    {
        # set window title to executing command and argments
        print -n "\033]2;${3}\007"
    }
    add-zsh-hook -Uz preexec my_preexec_setwindowtitle
fi

# ctrl+s, ctrl+q を無効化
stty -ixon

bindkey -e

bindkey "^A" backward-word
bindkey "^B" beginning-of-line
bindkey "^C" send-break
bindkey "^I" menu-complete
bindkey "^T" expand-word
bindkey "^Z" forward-word

# <https://invisible-island.net/xterm/xterm.faq.html#xterm_arrows>
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

bindkey -M isearch "^M" accept-search
bindkey -M isearch "^J" accept-search
bindkey -M isearch "^[[A" vi-repeat-search
bindkey -M isearch "^[[B" vi-rev-repeat-search

# local settings(post loading)
for i in "${ZDOTDIR}"/post_rc/*.zsh(N) ; do
    source "${i}"
done
