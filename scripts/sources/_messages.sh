#!/usr/bin/env bash

# Outputs a newline character
message_newline() {
    echo
}

# Prints a message with a red heart emoji at the beginning
message_welcome() {
    echo -e "\e[1;31m❤\e[0m ${@}"
}

# Prints a message with a gray circle (symbolizing debug) at the beginning
message_debug() {
    echo -e "\e[1;37m∅\e[0m ${@}"
}

# Prints a message with a red biohazard symbol at the beginning, indicating a warning
message_warning() {
    echo -e "\e[1;31m☣\e[0m ${@}"
}

# Prints a message with a red cross mark at the beginning, indicating an error
message_error() {
    echo -e "\e[1;31m✗\e[0m ${@}"
}

# Prints a message with a white right arrow at the beginning, indicating information
message_info() {
    echo -e "\e[1;37m→\e[0m ${@}"
}

# Prints a message with a blue right double angle quotation mark at the beginning, suggesting something
message_suggestion() {
    echo -e "\e[1;34m»\e[0m ${@}"
}

# Prints a message with a green check mark at the beginning, indicating success
message_success() {
    echo -e "\e[1;32m✓\e[0m ${@}"
}

message_note() {
    # Prints a message with a yellow exclamation mark at the beginning, indicating a note
    echo -e "\e[1;33m!\e[0m ${@}"
}

# Prints a message with a blue question mark at the beginning, indicating a question
message_ask() {
    echo -e "\e[1;34m?\e[0m ${@}"
}

# Usage:
#   Start a background process with a message:
#     sleep 10 &
#     spinner "Processing..."
# Usage:
#   Start a command with output redirected to /dev/null and a message:
#     your_command > /dev/null &
#     spinner "Processing..."
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
        local reset="\r"

        # Reset the cursor position for the next spinner update
        printf $reset
    done

    # Clear the entire line once the process is complete
    printf "\r%-${COLUMNS}s\r" " "
}
