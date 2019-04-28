#!bash

_metacpan() {

    COMPREPLY=()
    local program=metacpan
    local cur=${COMP_WORDS[$COMP_CWORD]}
#    echo "COMP_CWORD:$COMP_CWORD cur:$cur" >>/tmp/comp
    declare -a FLAGS
    declare -a OPTIONS
    declare -a MYWORDS

    local INDEX=`expr $COMP_CWORD - 1`
    MYWORDS=("${COMP_WORDS[@]:1:$COMP_CWORD}")

    FLAGS=('--verbose' 'Be verbose' '-v' 'Be verbose' '--help' 'Show command help' '-h' 'Show command help')
    OPTIONS=('--format' 'Format output')
    __metacpan_handle_options_flags

    case $INDEX in

    0)
        __comp_current_options || return
        __metacpan_dynamic_comp 'commands' 'author'$'\t''Author'$'\n''distribution'$'\t''Distribution'$'\n''favorite'$'\t''Favorite'$'\n''help'$'\t''Show command help'$'\n''module'$'\t''Module'$'\n''release'$'\t''Release'

    ;;
    *)
    # subcmds
    case ${MYWORDS[0]} in
      _meta)
        __metacpan_handle_options_flags
        case $INDEX in

        1)
            __comp_current_options || return
            __metacpan_dynamic_comp 'commands' 'completion'$'\t''Shell completion functions'$'\n''pod'$'\t''Pod documentation'

        ;;
        *)
        # subcmds
        case ${MYWORDS[1]} in
          completion)
            __metacpan_handle_options_flags
            case $INDEX in

            2)
                __comp_current_options || return
                __metacpan_dynamic_comp 'commands' 'generate'$'\t''Generate self completion'

            ;;
            *)
            # subcmds
            case ${MYWORDS[2]} in
              generate)
                FLAGS+=('--zsh' 'for zsh' '--bash' 'for bash')
                OPTIONS+=('--name' 'name of the program (optional, override name in spec)')
                __metacpan_handle_options_flags
                case ${MYWORDS[$INDEX-1]} in
                  --format)
                    _metacpan_compreply "'JSON'"$'\n'"'YAML'"$'\n'"'Table'"$'\n'"'Data__Dumper'"$'\n'"'Data__Dump'"
                    return
                  ;;
                  --name)
                  ;;

                esac
                case $INDEX in

                *)
                    __comp_current_options || return
                ;;
                esac
              ;;
            esac

            ;;
            esac
          ;;
          pod)
            __metacpan_handle_options_flags
            case $INDEX in

            2)
                __comp_current_options || return
                __metacpan_dynamic_comp 'commands' 'generate'$'\t''Generate self pod'

            ;;
            *)
            # subcmds
            case ${MYWORDS[2]} in
              generate)
                __metacpan_handle_options_flags
                __comp_current_options true || return # no subcmds, no params/opts
              ;;
            esac

            ;;
            esac
          ;;
        esac

        ;;
        esac
      ;;
      author)
        __metacpan_handle_options_flags
        case $INDEX in

        1)
            __comp_current_options || return
            __metacpan_dynamic_comp 'commands' 'info'$'\t''Author info'$'\n''list'$'\t''Author list'$'\n''releases'$'\t''Releases by author'

        ;;
        *)
        # subcmds
        case ${MYWORDS[1]} in
          info)
            __metacpan_handle_options_flags
            case ${MYWORDS[$INDEX-1]} in
              --format)
                _metacpan_compreply "'JSON'"$'\n'"'YAML'"$'\n'"'Table'"$'\n'"'Data__Dumper'"$'\n'"'Data__Dump'"
                return
              ;;

            esac
            case $INDEX in
              2)
                  __comp_current_options || return
                    _metacpan_author_info_param_handle_completion
              ;;


            *)
                __comp_current_options || return
            ;;
            esac
          ;;
          list)
            OPTIONS+=('--fields' 'List of field names')
            __metacpan_handle_options_flags
            case ${MYWORDS[$INDEX-1]} in
              --format)
                _metacpan_compreply "'JSON'"$'\n'"'YAML'"$'\n'"'Table'"$'\n'"'Data__Dumper'"$'\n'"'Data__Dump'"
                return
              ;;
              --fields)
                _metacpan_author_list_option_fields_completion
              ;;

            esac
            case $INDEX in
              2)
                  __comp_current_options || return
                    _metacpan_author_list_param_handle_completion
              ;;


            *)
                __comp_current_options || return
            ;;
            esac
          ;;
          releases)
            OPTIONS+=('--fields' 'List of field names')
            __metacpan_handle_options_flags
            case ${MYWORDS[$INDEX-1]} in
              --format)
                _metacpan_compreply "'JSON'"$'\n'"'YAML'"$'\n'"'Table'"$'\n'"'Data__Dumper'"$'\n'"'Data__Dump'"
                return
              ;;
              --fields)
                _metacpan_author_releases_option_fields_completion
              ;;

            esac
            case $INDEX in
              2)
                  __comp_current_options || return
                    _metacpan_author_releases_param_handle_completion
              ;;


            *)
                __comp_current_options || return
            ;;
            esac
          ;;
        esac

        ;;
        esac
      ;;
      distribution)
        __metacpan_handle_options_flags
        case $INDEX in

        1)
            __comp_current_options || return
            __metacpan_dynamic_comp 'commands' 'info'$'\t''Distribution info'

        ;;
        *)
        # subcmds
        case ${MYWORDS[1]} in
          info)
            __metacpan_handle_options_flags
            case ${MYWORDS[$INDEX-1]} in
              --format)
                _metacpan_compreply "'JSON'"$'\n'"'YAML'"$'\n'"'Table'"$'\n'"'Data__Dumper'"$'\n'"'Data__Dump'"
                return
              ;;

            esac
            case $INDEX in
              2)
                  __comp_current_options || return
                    _metacpan_distribution_info_param_distribution_completion
              ;;


            *)
                __comp_current_options || return
            ;;
            esac
          ;;
        esac

        ;;
        esac
      ;;
      favorite)
        __metacpan_handle_options_flags
        case $INDEX in

        1)
            __comp_current_options || return
            __metacpan_dynamic_comp 'commands' 'info'$'\t''Favorite info'$'\n''list'$'\t''Favorite list'

        ;;
        *)
        # subcmds
        case ${MYWORDS[1]} in
          info)
            __metacpan_handle_options_flags
            case ${MYWORDS[$INDEX-1]} in
              --format)
                _metacpan_compreply "'JSON'"$'\n'"'YAML'"$'\n'"'Table'"$'\n'"'Data__Dumper'"$'\n'"'Data__Dump'"
                return
              ;;

            esac
            case $INDEX in
              2)
                  __comp_current_options || return
                    _metacpan_favorite_info_param_distribution_completion
              ;;


            *)
                __comp_current_options || return
            ;;
            esac
          ;;
          list)
            OPTIONS+=('--fields' 'List of field names')
            __metacpan_handle_options_flags
            case ${MYWORDS[$INDEX-1]} in
              --format)
                _metacpan_compreply "'JSON'"$'\n'"'YAML'"$'\n'"'Table'"$'\n'"'Data__Dumper'"$'\n'"'Data__Dump'"
                return
              ;;
              --fields)
                _metacpan_favorite_list_option_fields_completion
              ;;

            esac
            case $INDEX in
              2)
                  __comp_current_options || return
                    _metacpan_favorite_list_param_distribution_completion
              ;;


            *)
                __comp_current_options || return
            ;;
            esac
          ;;
        esac

        ;;
        esac
      ;;
      help)
        FLAGS+=('--all' '')
        __metacpan_handle_options_flags
        case $INDEX in

        1)
            __comp_current_options || return
            __metacpan_dynamic_comp 'commands' 'author'$'\n''distribution'$'\n''favorite'$'\n''module'$'\n''release'

        ;;
        *)
        # subcmds
        case ${MYWORDS[1]} in
          _meta)
            __metacpan_handle_options_flags
            case $INDEX in

            2)
                __comp_current_options || return
                __metacpan_dynamic_comp 'commands' 'completion'$'\n''pod'

            ;;
            *)
            # subcmds
            case ${MYWORDS[2]} in
              completion)
                __metacpan_handle_options_flags
                case $INDEX in

                3)
                    __comp_current_options || return
                    __metacpan_dynamic_comp 'commands' 'generate'

                ;;
                *)
                # subcmds
                case ${MYWORDS[3]} in
                  generate)
                    __metacpan_handle_options_flags
                    __comp_current_options true || return # no subcmds, no params/opts
                  ;;
                esac

                ;;
                esac
              ;;
              pod)
                __metacpan_handle_options_flags
                case $INDEX in

                3)
                    __comp_current_options || return
                    __metacpan_dynamic_comp 'commands' 'generate'

                ;;
                *)
                # subcmds
                case ${MYWORDS[3]} in
                  generate)
                    __metacpan_handle_options_flags
                    __comp_current_options true || return # no subcmds, no params/opts
                  ;;
                esac

                ;;
                esac
              ;;
            esac

            ;;
            esac
          ;;
          author)
            __metacpan_handle_options_flags
            case $INDEX in

            2)
                __comp_current_options || return
                __metacpan_dynamic_comp 'commands' 'info'$'\n''list'$'\n''releases'

            ;;
            *)
            # subcmds
            case ${MYWORDS[2]} in
              info)
                __metacpan_handle_options_flags
                __comp_current_options true || return # no subcmds, no params/opts
              ;;
              list)
                __metacpan_handle_options_flags
                __comp_current_options true || return # no subcmds, no params/opts
              ;;
              releases)
                __metacpan_handle_options_flags
                __comp_current_options true || return # no subcmds, no params/opts
              ;;
            esac

            ;;
            esac
          ;;
          distribution)
            __metacpan_handle_options_flags
            case $INDEX in

            2)
                __comp_current_options || return
                __metacpan_dynamic_comp 'commands' 'info'

            ;;
            *)
            # subcmds
            case ${MYWORDS[2]} in
              info)
                __metacpan_handle_options_flags
                __comp_current_options true || return # no subcmds, no params/opts
              ;;
            esac

            ;;
            esac
          ;;
          favorite)
            __metacpan_handle_options_flags
            case $INDEX in

            2)
                __comp_current_options || return
                __metacpan_dynamic_comp 'commands' 'info'$'\n''list'

            ;;
            *)
            # subcmds
            case ${MYWORDS[2]} in
              info)
                __metacpan_handle_options_flags
                __comp_current_options true || return # no subcmds, no params/opts
              ;;
              list)
                __metacpan_handle_options_flags
                __comp_current_options true || return # no subcmds, no params/opts
              ;;
            esac

            ;;
            esac
          ;;
          module)
            __metacpan_handle_options_flags
            case $INDEX in

            2)
                __comp_current_options || return
                __metacpan_dynamic_comp 'commands' 'info'

            ;;
            *)
            # subcmds
            case ${MYWORDS[2]} in
              info)
                __metacpan_handle_options_flags
                __comp_current_options true || return # no subcmds, no params/opts
              ;;
            esac

            ;;
            esac
          ;;
          release)
            __metacpan_handle_options_flags
            case $INDEX in

            2)
                __comp_current_options || return
                __metacpan_dynamic_comp 'commands' 'info'

            ;;
            *)
            # subcmds
            case ${MYWORDS[2]} in
              info)
                __metacpan_handle_options_flags
                __comp_current_options true || return # no subcmds, no params/opts
              ;;
            esac

            ;;
            esac
          ;;
        esac

        ;;
        esac
      ;;
      module)
        __metacpan_handle_options_flags
        case $INDEX in

        1)
            __comp_current_options || return
            __metacpan_dynamic_comp 'commands' 'info'$'\t''Module'

        ;;
        *)
        # subcmds
        case ${MYWORDS[1]} in
          info)
            __metacpan_handle_options_flags
            case ${MYWORDS[$INDEX-1]} in
              --format)
                _metacpan_compreply "'JSON'"$'\n'"'YAML'"$'\n'"'Table'"$'\n'"'Data__Dumper'"$'\n'"'Data__Dump'"
                return
              ;;

            esac
            case $INDEX in
              2)
                  __comp_current_options || return
                    _metacpan_module_info_param_module_completion
              ;;


            *)
                __comp_current_options || return
            ;;
            esac
          ;;
        esac

        ;;
        esac
      ;;
      release)
        __metacpan_handle_options_flags
        case $INDEX in

        1)
            __comp_current_options || return
            __metacpan_dynamic_comp 'commands' 'info'$'\t''Release info'

        ;;
        *)
        # subcmds
        case ${MYWORDS[1]} in
          info)
            __metacpan_handle_options_flags
            case ${MYWORDS[$INDEX-1]} in
              --format)
                _metacpan_compreply "'JSON'"$'\n'"'YAML'"$'\n'"'Table'"$'\n'"'Data__Dumper'"$'\n'"'Data__Dump'"
                return
              ;;

            esac
            case $INDEX in
              2)
                  __comp_current_options || return
                    _metacpan_release_info_param_distribution_completion
              ;;


            *)
                __comp_current_options || return
            ;;
            esac
          ;;
        esac

        ;;
        esac
      ;;
    esac

    ;;
    esac

}

_metacpan_compreply() {
    IFS=$'\n' COMPREPLY=($(compgen -W "$1" -- ${COMP_WORDS[COMP_CWORD]}))

    # http://stackoverflow.com/questions/7267185/bash-autocompletion-add-description-for-possible-completions
    if [[ ${#COMPREPLY[*]} -eq 1 ]]; then # Only one completion
        COMPREPLY=( ${COMPREPLY[0]%% -- *} ) # Remove ' -- ' and everything after
        COMPREPLY=( ${COMPREPLY[0]%% *} ) # Remove trailing spaces
    fi
}

_metacpan_author_info_param_handle_completion() {
    local __dynamic_completion
    __dynamic_completion=`PERL5_APPSPECRUN_SHELL=bash PERL5_APPSPECRUN_COMPLETION_PARAMETER='handle' ${COMP_WORDS[@]}`
    __metacpan_dynamic_comp 'handle' "$__dynamic_completion"
}
_metacpan_author_list_option_fields_completion() {
    local __dynamic_completion
    __dynamic_completion=`PERL5_APPSPECRUN_SHELL=bash PERL5_APPSPECRUN_COMPLETION_PARAMETER='fields' ${COMP_WORDS[@]}`
    __metacpan_dynamic_comp 'fields' "$__dynamic_completion"
}
_metacpan_author_list_param_handle_completion() {
    local __dynamic_completion
    __dynamic_completion=`PERL5_APPSPECRUN_SHELL=bash PERL5_APPSPECRUN_COMPLETION_PARAMETER='handle' ${COMP_WORDS[@]}`
    __metacpan_dynamic_comp 'handle' "$__dynamic_completion"
}
_metacpan_author_releases_option_fields_completion() {
    local __dynamic_completion
    __dynamic_completion=`PERL5_APPSPECRUN_SHELL=bash PERL5_APPSPECRUN_COMPLETION_PARAMETER='fields' ${COMP_WORDS[@]}`
    __metacpan_dynamic_comp 'fields' "$__dynamic_completion"
}
_metacpan_author_releases_param_handle_completion() {
    local __dynamic_completion
    __dynamic_completion=`PERL5_APPSPECRUN_SHELL=bash PERL5_APPSPECRUN_COMPLETION_PARAMETER='handle' ${COMP_WORDS[@]}`
    __metacpan_dynamic_comp 'handle' "$__dynamic_completion"
}
_metacpan_distribution_info_param_distribution_completion() {
    local __dynamic_completion
    __dynamic_completion=`PERL5_APPSPECRUN_SHELL=bash PERL5_APPSPECRUN_COMPLETION_PARAMETER='distribution' ${COMP_WORDS[@]}`
    __metacpan_dynamic_comp 'distribution' "$__dynamic_completion"
}
_metacpan_favorite_info_param_distribution_completion() {
    local __dynamic_completion
    __dynamic_completion=`PERL5_APPSPECRUN_SHELL=bash PERL5_APPSPECRUN_COMPLETION_PARAMETER='distribution' ${COMP_WORDS[@]}`
    __metacpan_dynamic_comp 'distribution' "$__dynamic_completion"
}
_metacpan_favorite_list_option_fields_completion() {
    local __dynamic_completion
    __dynamic_completion=`PERL5_APPSPECRUN_SHELL=bash PERL5_APPSPECRUN_COMPLETION_PARAMETER='fields' ${COMP_WORDS[@]}`
    __metacpan_dynamic_comp 'fields' "$__dynamic_completion"
}
_metacpan_favorite_list_param_distribution_completion() {
    local __dynamic_completion
    __dynamic_completion=`PERL5_APPSPECRUN_SHELL=bash PERL5_APPSPECRUN_COMPLETION_PARAMETER='distribution' ${COMP_WORDS[@]}`
    __metacpan_dynamic_comp 'distribution' "$__dynamic_completion"
}
_metacpan_module_info_param_module_completion() {
    local __dynamic_completion
    __dynamic_completion=`PERL5_APPSPECRUN_SHELL=bash PERL5_APPSPECRUN_COMPLETION_PARAMETER='module' ${COMP_WORDS[@]}`
    __metacpan_dynamic_comp 'module' "$__dynamic_completion"
}
_metacpan_release_info_param_distribution_completion() {
    local __dynamic_completion
    __dynamic_completion=`PERL5_APPSPECRUN_SHELL=bash PERL5_APPSPECRUN_COMPLETION_PARAMETER='distribution' ${COMP_WORDS[@]}`
    __metacpan_dynamic_comp 'distribution' "$__dynamic_completion"
}

__metacpan_dynamic_comp() {
    local argname="$1"
    local arg="$2"
    local comp name desc cols desclength formatted
    local max=0

    while read -r line; do
        name="$line"
        desc="$line"
        name="${name%$'\t'*}"
        if [[ "${#name}" -gt "$max" ]]; then
            max="${#name}"
        fi
    done <<< "$arg"

    while read -r line; do
        name="$line"
        desc="$line"
        name="${name%$'\t'*}"
        desc="${desc/*$'\t'}"
        if [[ -n "$desc" && "$desc" != "$name" ]]; then
            # TODO portable?
            cols=`tput cols`
            [[ -z $cols ]] && cols=80
            desclength=`expr $cols - 4 - $max`
            formatted=`printf "%-*s -- %-*s" "$max" "$name" "$desclength" "$desc"`
            comp="$comp$formatted"$'\n'
        else
            comp="$comp'$name'"$'\n'
        fi
    done <<< "$arg"
    _metacpan_compreply "$comp"
}

function __metacpan_handle_options() {
    local i j
    declare -a copy
    local last="${MYWORDS[$INDEX]}"
    local max=`expr ${#MYWORDS[@]} - 1`
    for ((i=0; i<$max; i++))
    do
        local word="${MYWORDS[$i]}"
        local found=
        for ((j=0; j<${#OPTIONS[@]}; j+=2))
        do
            local option="${OPTIONS[$j]}"
            if [[ "$word" == "$option" ]]; then
                found=1
                i=`expr $i + 1`
                break
            fi
        done
        if [[ -n $found && $i -lt $max ]]; then
            INDEX=`expr $INDEX - 2`
        else
            copy+=("$word")
        fi
    done
    MYWORDS=("${copy[@]}" "$last")
}

function __metacpan_handle_flags() {
    local i j
    declare -a copy
    local last="${MYWORDS[$INDEX]}"
    local max=`expr ${#MYWORDS[@]} - 1`
    for ((i=0; i<$max; i++))
    do
        local word="${MYWORDS[$i]}"
        local found=
        for ((j=0; j<${#FLAGS[@]}; j+=2))
        do
            local flag="${FLAGS[$j]}"
            if [[ "$word" == "$flag" ]]; then
                found=1
                break
            fi
        done
        if [[ -n $found ]]; then
            INDEX=`expr $INDEX - 1`
        else
            copy+=("$word")
        fi
    done
    MYWORDS=("${copy[@]}" "$last")
}

__metacpan_handle_options_flags() {
    __metacpan_handle_options
    __metacpan_handle_flags
}

__comp_current_options() {
    local always="$1"
    if [[ -n $always || ${MYWORDS[$INDEX]} =~ ^- ]]; then

      local options_spec=''
      local j=

      for ((j=0; j<${#FLAGS[@]}; j+=2))
      do
          local name="${FLAGS[$j]}"
          local desc="${FLAGS[$j+1]}"
          options_spec+="$name"$'\t'"$desc"$'\n'
      done

      for ((j=0; j<${#OPTIONS[@]}; j+=2))
      do
          local name="${OPTIONS[$j]}"
          local desc="${OPTIONS[$j+1]}"
          options_spec+="$name"$'\t'"$desc"$'\n'
      done
      __metacpan_dynamic_comp 'options' "$options_spec"

      return 1
    else
      return 0
    fi
}


complete -o default -F _metacpan metacpan

