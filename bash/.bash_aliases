#!/bin/bash
# vi: sw=4 ts=4 et ai

# -------------------- aliases ---------------------------------------
alias jmake='make -j$(nproc) | tee > makeout.log'

# -------------------- functions -------------------------------------
dotenv() {
    if [[ $# -lt 1 ]];then
        echo "usage: dotenv <FILE>..."
        return 1
    fi
    local envfile name value
    for envfile in "$@";do
        [[ ! -e "$envfile" ]] && echo "$envfile not found" && return 1
        while IFS= read -r line; do
            name=${line%%=*}
            value=${line#*=}
            [[ -z "${name}" || $name =~ ^# ]] && continue
            export "$name"="$value"
        done <"$envfile"
    done
} && export -f dotenv

