# make git submodules usable
#   This overwrites the 'git' command with modifications where necessary, and
#   calls the original otherwise
git() {
    if [[ $@ == clone* ]]; then
        gitargs=$(echo "$@" | cut -c6-)
        command git clone --recursive $gitargs
    elif [[ $@ == pull* ]]; then
        command git "$@" && git submodule update --init --recursive
    elif [[ $@ == checkout* ]]; then
        command git "$@" && git submodule update --init --recursive
    else
        command git "$@"
    fi
}