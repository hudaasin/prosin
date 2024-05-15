#!/usr/bin/env bash

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
    read -r -p "$(tput setaf 4)?$(tput sgr0) $1 (y/N)? " response
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
    read -r -p "$(tput setaf 4)?$(tput sgr0) $1 " answer

    echo "${answer}"
}

# Function: convert_to_absolute_path
# Description: Converts a relative path to an absolute path.
# Arguments:
#   $1: The relative path to convert.
# Returns:
#   The absolute path.
convert_to_absolute_path() {
    local relative_path="${1}"
    local absolute_path

    # Check if the path exists
    if [ -e "${relative_path}" ]; then
        absolute_path=$(realpath "${relative_path}")
        echo "${absolute_path}"
    else
        message_error "The path '${relative_path}' does not exist."
        exit 1
    fi
}

# Function: find_common_elements
# Description: Finds common elements between two lists.
# Arguments:
#   $1: The first list.
#   $2: The second list.
# Returns:
#   An array containing the common elements.
find_common_elements() {
    local list1=($1)
    local list2=($2)

    local common_items=()

    for item1 in "${list1[@]}"; do
        for item2 in "${list2[@]}"; do
            if [ "$item1" == "$item2" ]; then
                common_items+=("$item1")
            fi
        done
    done

    echo "${common_items[@]}"
}

# Function: check_string_in_array
# Description: Checks if a string exists in an array.
# Arguments:
#   $1: The string to search for.
#   ${@:2}: The array to search in.
# Returns:
#   0 if the string is found in the array, 1 otherwise.
check_string_in_array() {
    local search_string=$1
    local array=("${@:2}")

    for element in "${array[@]}"; do
        if [ "$element" == "$search_string" ]; then
            return 0
        fi
    done

    return 1
}

# Function: find_common_packages
# Description: Finds common packages between two files containing package names.
# Arguments:
#   $1: Path to the first file.
#   $2: Path to the second file.
# Returns:
#   An array containing the common package names.
find_common_packages() {
    local file1=$1
    local file2=$2

    local common_packages=()

    while IFS= read -r package1; do
        while IFS= read -r package2; do
            if [ "$package1" == "$package2" ]; then
                common_packages+=("$package1")
            fi
        done <"$file2"
    done <"$file1"

    echo "${common_packages[@]}"
}

# Function: array_to_string
# Description: Converts an array to a space-separated string.
# Arguments:
#   $@: The array to convert.
# Returns:
#   A space-separated string of array elements.
array_to_string() {
    local array=("$@")
    local array_string=""

    # Iterate over the array elements and concatenate them into a string
    for element in "${array[@]}"; do
        array_string+=" $element" # Add space between elements
    done

    # Remove leading space (optional)
    array_string="${array_string:1}"

    echo "$array_string"
}

# Function: convert_array
# Description: Converts an array with space-separated elements to individual elements.
# Arguments:
#   $@: The array to convert.
# Returns:
#   An array with individual elements.
convert_array() {
    local initial_array=("$@")
    local new_array=()

    for pkg in "${initial_array[@]}"; do
        if [[ $pkg == *" "* ]]; then
            IFS=' ' read -r -a split_pkgs <<<"$pkg"
            new_array+=("${split_pkgs[@]}")
        else
            new_array+=("$pkg")
        fi
    done

    printf '%s\n' "${new_array[@]}"
}

# Function: get_files_in_directory
# Description: Retrieves a list of files in a specified directory.
# Arguments:
#   $1: The directory to search for files.
# Returns:
#   An array containing the files in the directory.
get_files_in_directory() {
    local directory="$1"
    local files=()

    # Check if the directory exists
    if [ -d "$directory" ]; then
        # Get all files in the directory and store them in the array
        files=("$directory"/*)
    else
        echo "Error: Directory $directory does not exist."
        exit 1
    fi

    # Output the array of files
    printf '%s\n' "${files[@]}"
}

# Function: get_file_name
# Description: Extracts the file name from a given file path.
# Arguments:
#   $1: The file path from which to extract the file name.
# Returns:
#   The extracted file name.
get_file_name() {
    local file_path="$1"
    local file_name=$(basename "$file_path")
    echo "$file_name"
}

# Function: select_packages_for_installation
#
# Description: Allows the user to select packages for installation from a list of available packages.
#
# Parameters:
#   $@: List of package names
#
# Returns:
#   List of selected packages
#
# Example usage:
#   select_packages_for_installation "package1" "package2" "package3"
#
select_packages_for_installation() {
    local packages=("$@")      # Store the list of package names in an array
    local selected_packages=() # Array to store selected packages

    echo "Available packages for installation:"
    for package in "${packages[@]}"; do
        echo "- $package"
    done

    echo "Enter the package names you want to install (separated by spaces):"
    read -r input_packages

    # Split user input into an array
    IFS=' ' read -r -a selected <<<"$input_packages"

    # Check selected packages against the available packages
    for package in "${selected[@]}"; do
        if [[ " ${packages[@]} " =~ " $package " ]]; then
            selected_packages+=("$package")
        else
            echo "Warning: '$package' is not a valid package name."
        fi
    done

    # Return the list of selected packages
    echo "${selected_packages[@]}"
}

# Function to check the status of a specific service
# Args:
#   $1: the name of the service to check
# Returns:
#   0 if the service is running, 1 if it is not running
check_service_status() {
    local service_name="$1" # Assign the input parameter (service name) to a local variable

    # Check if the specified service is running by searching for its name in the list of running containers
    if docker compose ps --format '{{.Names}}' | grep "${service_name}\$" >/dev/null; then
        return 0 # Return 0 to indicate that the service is running
    else
        return 1 # Return 1 to indicate that the service is not running
    fi
}
