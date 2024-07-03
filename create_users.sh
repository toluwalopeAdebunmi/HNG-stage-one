#!/bin/bash

# Configuration
SECURE_DIR="/var/secure"
SECURE_FILE="$SECURE_DIR/user_passwords.txt"
LOG_DIR="/var/log"
LOG_FILE="$LOG_DIR/user_management.log"
PASSWORD_LENGTH=8

# Create directory and file with specified permissions and ownership
setup_environment() {
    local dir=$1
    local file=$2
    local owner=$3
    local dir_perms=$4
    local file_perms=$5

    mkdir -p "$dir"
    touch "$file"
    
    chown "$owner:$owner" "$dir" "$file"
    chmod "$dir_perms" "$dir"
    chmod "$file_perms" "$file"
}

# Initialize directories and files
initialize() {
    setup_environment "$LOG_DIR" "$LOG_FILE" "${SUDO_USER:-$(whoami)}" 755 644
    setup_environment "$SECURE_DIR" "$SECURE_FILE" "${SUDO_USER:-$(whoami)}" 700 600
}

# Ensure script is run with required arguments
validate_input() {
    if [ $# -eq 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Usage: $0 <input_file>" | tee -a "$LOG_FILE"
        exit 1
    fi
}

# Ensure the script is run with root privileges
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - This script must be run as root or with sudo." | tee -a "$LOG_FILE"
        echo -e "Usage:\nsudo $0 <file.txt>"
        exit 1
    fi
}

# Generate a random password
generate_password() {
    tr -dc '[:alnum:]' < /dev/urandom | head -c "$PASSWORD_LENGTH"
    echo
}

# Create a new user and set up their home directory
create_user() {
    local username=$1

    if id "$username" &>/dev/null; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - User '$username' already exists." | tee -a "$LOG_FILE"
        return 1
    fi

    local password=$(generate_password)
    echo "$username,$password" >> "$SECURE_FILE"

    useradd -m -s /bin/bash "$username"
    echo "$username:$password" | chpasswd

    if [ $? -eq 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - User '$username' created successfully." | tee -a "$LOG_FILE"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Failed to create user '$username'." | tee -a "$LOG_FILE"
    fi
}

# Assign user to specified groups
assign_to_groups() {
    local username=$1
    local groups=$2

    IFS=',' read -ra group_list <<< "$groups"
    for group in "${group_list[@]}"; do
        if ! getent group "$group" &>/dev/null; then
            groupadd "$group"
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Group '$group' created." | tee -a "$LOG_FILE"
        fi

        usermod -aG "$group" "$username"
        if [ $? -eq 0 ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - User '$username' added to group '$group'." | tee -a "$LOG_FILE"
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Failed to add user '$username' to group '$group'." | tee -a "$LOG_FILE"
        fi
    done
}

# Process input file to create users and assign groups
process_file() {
    local file=$1

    while IFS=';' read -r user groups || [ -n "$user" ]; do
        user=$(echo "$user" | tr -d ' ')
        groups=$(echo "$groups" | tr -d ' ')

        create_user "$user"
        assign_to_groups "$user" "$groups"
    done < "$file"
}

# Main script execution
main() {
    validate_input "$@"
    check_root
    initialize

    local input_file=$1
    process_file "$input_file"

    echo "Completed"
}

# Run the main function
main "$@"

