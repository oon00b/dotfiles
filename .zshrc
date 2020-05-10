# local settings
[[ -r "${ZDOTDIR:-${HOME}}/.zshrc_local" ]] && source "${ZDOTDIR:-${HOME}}/.zshrc_local"

autoload -Uz compinit add-zsh-hook vcs_info

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
setopt PRINT_EXIT_VALUE

setopt APPEND_CREATE

setopt COMBINING_CHARS

export PS1="%F{yellow}%c%f %(!.[%F{red}#%f] .)"

# part of a word except [[:alnum:]]
export WORDCHARS="!#$%^~\\@+:*?_"

[[ -n "${HISTFILE}" ]] || export HISTFILE="${ZDOTDIR:-${HOME}}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

export EDITOR="vim"
export VISUAL="vim"
export MANPAGER="vim -M +MANPAGER -"

# GNU ls
if test -r "${HOME}/.dir_colors" && command -v dircolors >| "/dev/null" 2>&1 ; then
    eval $(dircolors "${HOME}/.dir_colors")
else
    export LS_COLORS="di=34:ln=35:so=36:pi=32:ex=31:bd=30;46:cd=30;44:su=37;41:sg=30;41:tw=30;45:ow=30;43:st=30;42:"
fi
# BSD ls
export LSCOLORS="exfxgxcxbxagaehbabafad"

if ls --color=auto >| "/dev/null" 2>&1 ; then
    # GNU ls
    alias ls="ls -A -F --color=auto"
elif ls -G >| "/dev/null" 2>&1 ; then
    # BSD ls
    alias ls="ls -A -F -G"
else
    alias ls="ls -A -F"
fi

alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

compinit
[[ "${ZDOTDIR:-${HOME}}/.zcompdump.zwc" -nt \
   "${ZDOTDIR:-${HOME}}/.zcompdump" ]] || zcompile "${ZDOTDIR:-${HOME}}/.zcompdump"

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

# store compcache in "${ZDOTDIR:-HOME}/.zcompcache/"
zstyle ":completion:*" use-cache "true"

# vcs
zstyle ":vcs_info:*" check-for-changes "true"
zstyle ":vcs_info:*" stagedstr "[%F{yellow}S%f]"
zstyle ":vcs_info:*" unstagedstr "[%F{red}U%f]"
zstyle ":vcs_info:*" formats "%%F{green}%b%%f@%%F{blue}%r%%f.%%F{magenta}%s%f%c%u"

my_precmd_setrprompt()
{
    vcs_info
    # "branch"@"repo"."vcs"["staged"]["unstaged"]
    export RPS1="${vcs_info_msg_0_}"
}
add-zsh-hook -Uz precmd my_precmd_setrprompt

my_chpwd_autols()
{
    ls
}
add-zsh-hook -Uz chpwd my_chpwd_autols

# OSC 2 ; Pt BEL (change window title to Pt)
# <https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Operating-System-Commands>
if [[ "${TERM}" =~ "xterm|konsole|alacritty|tmux|screen|st" ]] ; then
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

[[ "${ZDOTDIR:-${HOME}}/.zshrc.zwc" -nt \
   "${ZDOTDIR:-${HOME}}/.zshrc" ]] || zcompile "${ZDOTDIR:-${HOME}}/.zshrc"
