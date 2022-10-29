autoload -U add-zsh-hook

check_project_after_cd() {
	local root="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [[ ${root} = "" ]]; then
        export RPROMPT="😑 "
    else
        execute_project_file $root
    fi
}

execute_project_file() {
    local artisan_file="$1/.artisan.zsh" 
    if [[ -f ${artisan_file} ]]; then
        export RPROMPT="🐝✅"
        zsh ${artisan_file}
    else
        export RPROMPT="🐝❌"
    fi
}

add-zsh-hook chpwd check_project_after_cd
