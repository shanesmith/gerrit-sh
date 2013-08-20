#!/bin/bash

_gerrit() {
    local cur prev opts

    opts="config projects clone status st push draft assign checkout co rechecout reco review submit abandon pubmit ninja ssh"

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    case "${prev}" in
      gerrit)
        COMPREPLY=( $(compgen -W "${opts}" -- $cur) )
        ;;
    esac
}

complete -F _gerrit gerrit
