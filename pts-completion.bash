# ZSH support
if [[ -n "$ZSH_VERSION" ]]; then
    autoload -U +X compinit && compinit
    autoload -U +X bashcompinit && bashcompinit
    echo "why doesn't this work!!!"
fi

_pts_completions() {

    pokemon_list='
    random
    rhyhorn
    ns:random
    s:random
    '

    # TODO
    # take pokemon list and iterate to add s/ns
    # TODO complete off existing ns:/s:

    COMPREPLY=($(compgen -W "$pokemon_list" "${COMP_WORDS[${COMP_CWORD}]}"))

}

# change ./pts to pts after install
IFS=$'\n' complete -F _pts_completions ./pts
