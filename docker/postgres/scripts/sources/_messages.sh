#!/usr/bin/env bash

# Function to print a newline
message_newline() {
    echo
}

# Function to show a welcoming message in bold text with a heart icon
message_welcome() {
    echo -e "\e[1;31m❤\e[0m ${@}"
}

# Function to display a debug message with a snowflake icon
message_debug() {
    echo -e "\e[1;37m∅\e[0m ${@}"
}

# Function to indicate a warning message in red-orange color with a biohazard icon
message_warning() {
    echo -e "\e[1;31m☣\e[0m ${@}"
}

# Function to highlight an error message in red color with a cross mark icon
message_error() {
    echo -e "\e[1;31m✗\e[0m ${@}"
}

# Function to present an informative message in yellow color with a right arrow icon
message_info() {
    echo -e "\e[1;37m→\e[0m ${@}"
}

# Function to offer a suggestion message in blue color with a double arrow icon
message_suggestion() {
    echo -e "\e[1;34m»\e[0m ${@}"
}

# Function to announce a success message in green color with a check mark icon
message_success() {
    echo -e "\e[1;32m✓\e[0m ${@}"
}

# Function to display a note message in green color with an exclamation mark icon
message_note() {
    echo -e "\e[1;33m!\e[0m ${@}"
}

# This function is used to display a message in blue color with a question mark prefix.
message_ask() {
    echo -e "\e[1;34m?\e[0m ${@}"
}

spinner() {
    # Accepts a message as input
    local info="$1"
    
    # Get the process ID of the background process
    local pid=$!
    
    # Set the delay for the spinner animation
    local delay=0.5
    
    # Define the spinner characters
    local spinstr='|/-\'
    
    # Loop until the background process is running
    while kill -0 $pid 2>/dev/null; do
        # Rotate the spinner characters
        local temp=${spinstr#?}
        printf " [%c]  %s" "$spinstr" "$info"
        local spinstr=$temp${spinstr%"$temp"}
        
        # Add backspace characters to reset the cursor position
        sleep $delay
        local reset="\b\b\b\b\b\b"
        for ((i = 1; i <= $(echo $info | wc -c); i++)); do
            reset+="\b"
        done
        
        # Reset the cursor position for the next spinner update
        printf $reset
    done
    
    # Clear the spinner and message once the process is complete
    printf "    \b\b\b\b"
}
