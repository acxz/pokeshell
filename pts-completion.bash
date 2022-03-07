# zsh support
if [[ -n "$ZSH_VERSION" ]]; then
    autoload -U +X compinit && compinit
    autoload -U +X bashcompinit && bashcompinit
    # TODO can't get zsh to work ;(
fi

_pts_completions() {

    # TODO add more pokemon?
    pokemon_list='
    random
    rhyhorn
    '

    curr_arg=${COMP_WORDS[${COMP_CWORD}]}
    curr_arg=${curr_arg/ns:/}
    curr_arg=${curr_arg/s:/}
    if [ "$curr_arg" = ':' ]; then
        curr_arg=''
    fi

    COMPREPLY=($(compgen -W "$pokemon_list" "${curr_arg}"))

}

# change ./pts to pts after install
IFS=$'\n' complete -F _pts_completions ./pts
