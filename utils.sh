print_in_color() {
    printf "%b" \
        "$(tput setaf "$2" 2> /dev/null)" \
        "$1" \
        "$(tput sgr0 2> /dev/null)"
}

print_in_red() {
    print_in_color "$1" 1
}

print_in_green() {
    print_in_color "$1" 2
}

print_success() {
    print_in_green "   [✔] $1\n"
}

print_error() {
    print_in_red "   [✖] $1 $2\n"
}

print_error_stream() {
    while read -r line; do
        print_error "↳ ERROR: $line"
    done
}

print_result() {

    if [ "$1" -eq 0 ]; then
        print_success "$2"
    else
        print_error "$2"
    fi

    return "$1"

}

show_spinner() {

    local -r FRAMES='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

    local -r NUMBER_OR_FRAMES=${#FRAMES}

    local -r PID="$1"

    local -r MSG="$2"

    local i=0
    local frameText=""

    # Display spinner while the process are being executed.

    while kill -0 "$PID" &>/dev/null; do

        frameText="   [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"

        printf "%s" "$frameText"

        sleep 0.2

        printf "\r"

    done
}


execute() {

    local -r CMDS="$1"
    local -r MSG="${2:-$1}"
    local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

    local exitCode=0
    local cmdsPID=""

    # If the current process is ended,
    # also end all its subprocesses.
    trap "kill_all_subprocesses" "EXIT"

    # Execute commands in background
    eval "$CMDS" 1> /dev/null 2> "$TMP_FILE" &
    cmdsPID=$!

    # Show a spinner if the commands
    show_spinner "$cmdsPID" "$MSG"

    # Wait for the commands to no longer be executing
    # in the background, and then get their exit code.
    wait "$cmdsPID" &> /dev/null
    exitCode=$?

    # Print output based on what happened.
    print_result $exitCode "$MSG"

    if [ $exitCode -ne 0 ]; then
        print_error_stream < "$TMP_FILE"
    fi

    rm -rf "$TMP_FILE"

    return $exitCode

}
