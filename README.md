Linux User Management bash Script 

Overview Purpose

The create_users.sh script automates the process of user and group creation based on input from a text file. It reads usernames and associated groups, creates users with their respective personal groups, sets up home directories, generates random passwords, logs all actions, and securely stores passwords.

Usage
To use the script, follow these steps:

1. Ensure you have the text file containing usernames and groups formatted as username;groups.
2. Run the script with the text file as the argument:
bash create_users.sh <name-of-text-file>

Functionality

User and Group Creation
Each user specified in the text file is created.
Users are assigned their personal group (same as their username).
Additional groups specified for each user are also created if they don't exist.

Directory and File Setup
The script checks for and creates necessary directories and files:

1. Secure Directory and File:
Directory: /var/secure
File: user_passwords.txt
Permissions: Directory 700, File 600

2. Log Directory and File:
Directory: /var/log
File: user_management.log
Permissions: Directory 755, File 644

Password Generation
Random passwords are generated for each user.
Passwords are securely stored in /var/secure/user_passwords.txt with permissions restricted to the file owner.

Logging
All actions performed by the script are logged to /var/log/user_management.log.
Logging includes user and group creation, password generation, and any errors encountered.
Error Handling
* The script handles scenarios such as existing users or groups gracefully.
* Errors and warnings are logged to provide visibility into any issues encountered during execution.
