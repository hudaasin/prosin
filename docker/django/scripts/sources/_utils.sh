#!/usr/bin/env sh

# Function: yes_no
# Description: Prompts the user for a yes/no response and returns 0 for "yes" and 1 for anything else.
# Arguments:
#   $1: The message to display to the user.
# Returns:
#   0 if the user responds with "yes", 1 for any other response.
# Usage: if yes_no "Do you want to proceed?"; then
#            # Proceed with the operation
#        else
#            # Cancel the operation
#        fi
yes_no() {
    local response=""
    echo -n "$(tput setaf 4)?$(tput sgr0) $1 (y/N)? "
    read response
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

# Function: change_ownership
# Description: Changes the ownership of a file or folder and its contents to a specified UID.
# Parameters:
#   $1: Path to the file or folder
#   $2: UID to set as the ownership
# Returns:
#   0: Successful ownership change
#   1: Error in providing path or UID
#   2: Path does not exist
change_ownership() {
    # Check if path and UID are provided
    if [ $# -lt 2 ]; then
        return 1
    fi

    local path=$1
    local uid=$2

    # Check if the path exists
    if [ ! -e "$path" ]; then
        return 2
    fi

    # Change ownership recursively
    chown -R $uid:$uid $path
}

# Function to retrieve the Django version without the patch version
# Usage: django_version=$(get_django_version)
# Returns: Django version number without the patch version (e.g., 4.2)
get_django_version() {
    local version=$(python -m django --version)
    local django_version=$(echo $version | cut -d '.' -f 1,2)
    echo $django_version
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
