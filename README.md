# Linux User Management Bash Script

## Overview and Purpose

The create_users.sh script automates the process of user and group creation based on input from a text file. It reads usernames and associated groups, creates users with their respective personal groups, sets up home directories, generates random passwords, logs all actions, and securely stores passwords.

## Usage
To use the script, follow these steps:

1. Ensure you have the text file containing usernames and groups formatted as username;groups.
2. Run the script with the text file as the argument:
`sudo bash create_users.sh <name-of-text-file>`

## Directory and File Setup
The script checks for and creates necessary directories and files:

1. Secure Directory and File:

Directory: `/var/secure`
File: `user_passwords.txt`
Permissions: Directory `700`, File `600`

3. Log Directory and File:

Directory: `/var/log`
File: `user_management.log`
Permissions: Directory `755, File 644`

## User and Group Creation
1. Each user specified in the text file is created.
2. Users are assigned their personal group (same as their username).
3. Additional groups specified for each user are also created if they don't exist.

## Password Generation
1. Random passwords are generated for each user.
2. Passwords are securely stored in `/var/secure/user_passwords.txt` with permissions restricted to the file owner.

## Logging
1. All actions performed by the script are logged to /`var/log/user_management.log`.
2. Logging includes user and group creation, password generation, and any errors encountered.

## Error Handling
1. The script handles scenarios such as existing users or groups gracefully.
2. Errors and warnings are logged to provide visibility into any issues encountered during execution.

## Security Considerations
1. Passwords are securely stored with restricted permissions (chmod 600).
2. Logging ensures traceability of actions taken by the script.
3. Input validation and error checking are implemented to prevent unexpected behavior.

## In conclusion

Using this script, you may effectively and safely manage user accounts and group memberships on a Linux system. For best results, make sure the input file is formatted correctly and that you execute it with the required permissions.
