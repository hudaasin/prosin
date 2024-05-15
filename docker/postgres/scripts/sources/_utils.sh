#!/usr/bin/env bash

# Function to prompt for confirmation (yes/no)
# This function displays a message to the user and prompts for a yes/no response.
# It reads the user's input and returns 0 for "yes" and 1 for anything else.
# Usage: if yes_no "Do you want to proceed?"; then
#            # Proceed with the operation
#        else
#            # Cancel the operation
#        fi
yes_no() {
    local response
    read -r -p "$1 (y/n)? " response
    case "$response" in
    [yY])
        return 0
        ;;
    *)
        return 1
        ;;
    esac
}

# Function: ask_question
# Description: Prompts the user for an answer to a question.
# Arguments:
#   $1: The question to ask the user.
# Returns:
#   The user's answer.
ask_question() {
    echo -n "$(tput setaf 4)?$(tput sgr0) $1 "
    read answer
    echo "${answer}"
}

# Function to create a countdown
countdown() {
    # Description of the function
    declare desc="A simple countdown."

    # Input parameter: number of seconds for the countdown
    local seconds="${1}"

    # Calculate the end time of the countdown
    local d=$(($(date +%s) + $seconds))

    # Loop until the end time is reached
    while [ "$d" -ge $(date +%s) ]; do
        # Print the remaining time in HH:MM:SS format
        echo -ne "$(date -u --date @$(($d - $(date +%s))) +%H:%M:%S)\r"

        # Wait for a short duration
        sleep 0.1
    done
}

# Function: convert_dotted_path_to_slash
# Description: Converts a dotted path to a path with slashes.
# Arguments:
#   $1: Dotted path to be converted
# Output: Path with slashes
convert_dotted_path_to_slash() {
    local dotted_path=$1
    local slash_path=$(echo "$dotted_path" | tr '.' '/')
    echo "$slash_path"
}

list_databases() {
    local username=${1}
    local password=${2}

    if [[ -z $1 ]] && [[ -z $2 ]]; then
        username=$POSTGRES_USER
        password=$POSTGRES_PASSWORD
    elif [[ -z $1 ]] || [[ -z $2 ]]; then
        message_error "Username or password is not specified yet it is a required parameter."
        exit 1
    fi

    # Get the list of databases
    local databases=($(psql -lqt | cut -d \| -f 1 | grep -v 'template0' | grep -v 'template1'))

    for database in "${databases[@]}"; do
        local num_tables=$(psql -d $database -c "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public';" | sed -n 3p)
        printf "  \e[1;31mName:\e[0m \e[37m%-15s\e[0m\e[1;32mNumber of tables:\e[0m \e[37m%s\e[0m\n" "$database" "$num_tables"
        # Add a new line at the end for better formatting
        # Add more information about the database here, such as size, last backup date, etc.
    done
}

# Function to convert Gregorian date to Persian (Hijri Shamsi) date
gregorian_to_persian() {
    echo "$(echo $(date +'%Y-%m-%d') | source "${workdir}/sources/_pcal.sh" -D "_")"
}

# Function: list_backups
# Description: Lists backup files based on a given pattern
# Arguments:
#   $1: pattern - the pattern to search for in backup filenames
#   $2: path (optional) - the directory path to search for backup files (default: $DBMS_BACKUP_DIR)
# Returns: None
list_backups() {
    local path="${2:-$DBMS_BACKUP_DIR}"

    # Find files matching the pattern in the specified path
    find "${path}" -type f \( -name "$1" \) -exec ls -lht --color=never {} + |
        awk '{ "stat -c %y " $9 | getline file_date; file=substr($9, 10); sub(/\.[0-9]+/, "", file_date); \
        printf "\033[1;31m  File:\033[0m %-55s \033[1;35mDate:\033[0m %-25s \033[1;32m\tSize:\033[0m %-10s \033[1;34mOwner:\033[0m %s\n", file, file_date, $5, $3}'
}

get_file_name() {
    local file_path="$1"
    echo $(basename "$file_path")
}
