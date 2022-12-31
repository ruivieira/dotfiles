autoload -U add-zsh-hook

export _ARTISAN_DEFAULT_VENV_PATH="${HOME}/.virtualenvs"

check_project_after_cd() {
	local root="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [[ ${root} = "" ]]; then
        export RPROMPT="😑 "
    else
        execute_project_file $root
    fi
}

_process_python_venv() {
    if [[ -v ARTISAN_VENV ]]; then
        local _NEW_VENV="${_ARTISAN_DEFAULT_VENV_PATH}/${ARTISAN_VENV}"
        local _NEW_VENV_CMD="${_NEW_VENV}/bin/activate"
        if [[ -f ${_NEW_VENV_CMD} ]]; then
            source $_NEW_VENV_CMD
        else
            if read -q "choice?🐍 venv ${_NEW_VENV} does not exist. Create [y/n]? "; then
                python3 -m venv ${_NEW_VENV}
                source $_NEW_VENV_CMD
            fi
        fi
    fi
}

_process_java() {

}

execute_project_file() {
    local artisan_file="$1/.artisan.zsh" 
    if [[ -f ${artisan_file} ]]; then
        export RPROMPT="🐝✅"
        . ${artisan_file}
        _process_python_venv

    else
        export RPROMPT="🐝❌"
    fi
}


add-zsh-hook chpwd check_project_after_cd
