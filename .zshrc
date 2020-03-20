### Options

# Changing Directories
setopt AUTO_CD

# Completion
setopt COMPLETE_IN_WORD
setopt GLOB_COMPLETE
setopt MENU_COMPLETE

# Expansion and Globbing
setopt GLOB_DOTS
setopt MARK_DIRS

# History
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_NO_FUNCTIONS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Input/Output
setopt NO_CLOBBER
setopt CORRECT
setopt IGNORE_EOF
setopt PRINT_EXIT_VALUE

# Shell Emulation
setopt APPEND_CREATE

# Zle
setopt COMBINING_CHARS

### Env

# prompt ("currentdir " + UID == 0 ? "# " : "")
export PS1="%U%c%u %(!.%F{red}#%f .)"

# history
[[ -n "${HISTFILE}" ]] || export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

# editor, pager
export EDITOR="vim"
export VISUAL="vim"
export MANPAGER="vim -M +MANPAGER -"

# color
export LS_COLORS="di=34:ln=35:so=36:pi=32:ex=31:bd=30;46:cd=30;44:su=37;41:sg=30;41:tw=30;47:ow=30;43:st=30;42:"
export LSCOLORS="exfxgxcxbxagaehbabahad"

### alias

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

### autoload

autoload -Uz compinit add-zsh-hook
compinit

### completion

zstyle ":completion:*" ignore-parents "parent" "pwd"
zstyle ":completion:*" squeeze-slashes "true"
zstyle ":completion:*" list-separator ""
zstyle ":completion:*" list-colors "${LS_COLORS}"
zstyle ":completion:*:descriptions" format "%F{green}-- %d --%f"
zstyle ":completion:*:messages" format "%F{yellow}%U%d%u%f"
zstyle ":completion:*:warnings" format "%F{red}no matches%f"
zstyle ":completion:*" group-name ""
zstyle ":completion:*" menu "select"

### Hook Functions

my_chpwd_autols()
{
    ls
}
add-zsh-hook -Uz chpwd my_chpwd_autols

# OSC 2 ; Pt BEL (change window title to Pt) <https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Operating-System-Commands>
if [[ "${TERM}" =~ "xterm|konsole" ]] ; then
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

### Zle

# <https://invisible-island.net/xterm/xterm.faq.html#xterm_arrows>
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey "^A" backward-word
bindkey "^Z" forward-word
bindkey "^B" beginning-of-line
