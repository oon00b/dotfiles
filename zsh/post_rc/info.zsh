viminfo () {
    vim -R -M -c "Info $1 $2" +only
}
compdef viminfo=info
alias info=viminfo
