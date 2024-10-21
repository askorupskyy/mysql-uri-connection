#!/bin/bash

MYSQL_URL=$1

# use regex to parse the MySQL URL
if [[ $MYSQL_URL =~ mysql://([^:]+)(:([^@]*))?@([^:]+):([0-9]+)/([a-zA-Z0-9_-]+) ]]; then
	USERNAME="${BASH_REMATCH[1]}"
	PASSWORD="${BASH_REMATCH[3]}" # This will be empty if the password is not provided
	HOSTNAME="${BASH_REMATCH[4]}"
	PORT="${BASH_REMATCH[5]}"
	DATABASE="${BASH_REMATCH[6]}"
else
	echo "Invalid MySQL URL format"
	exit 1
fi

if [[ -n "$PASSWORD" ]]; then
	# if password is provided in the URL, pass it with `-p`
	mysql -h "$HOSTNAME" -P "$PORT" -u "$USERNAME" --password="$PASSWORD" "$DATABASE" "$@"
else
	# if no password is provided, prompt for it interactively
	mysql -h "$HOSTNAME" -P "$PORT" -u "$USERNAME" "$DATABASE" "$@"
fi
