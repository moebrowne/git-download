#!/bin/bash

# Get the source directory
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Set the library root path
LIBRARY_PATH_ROOT="$DIR/libs"

# Include all libraries in the libs directory
for f in "$LIBRARY_PATH_ROOT"/*.sh; do
	# Include the directory
	source "$f"
done

# If no parameters were passed show the usage
if [ $# = 0 ]; then
	usage
fi

# Pad the arguments
args=" $@ "

# Config

# Git executable
EXEC_GIT="/usr/bin/git"

regexRepoURL=' -(-repo|r) ([^ ]+) '
[[ $args =~ $regexRepoURL ]]
if [ "${BASH_REMATCH[2]}" != "" ]; then
	REPO_URL="${BASH_REMATCH[2]}"

	# Determine the repos name
	regexRepoName=':([^/]+)/(.*)\.git'
	[[ ${BASH_REMATCH[2]} =~ $regexRepoName ]]
	if [ "${BASH_REMATCH[1]}" != "" ]; then
		REPO_NAME="${BASH_REMATCH[2]}"
	fi
fi

# Check we were given a repo name
if [ "$REPO_NAME" = "" ]; then
	echo "Repo name is required, please specify with the --repo or -r flag"
	exit 1
fi

regexRepoBranch=' -(-branch|b) ([^ ]+) '
[[ $args =~ $regexRepoBranch ]]
if [ "${BASH_REMATCH[2]}" != "" ]; then
	REPO_BRANCH="${BASH_REMATCH[2]}"
else
	REPO_BRANCH="master"
fi

regexRepoDirectory=' -(-directory|d) ([^ ]+) '
[[ $args =~ $regexRepoDirectory ]]
if [ "${BASH_REMATCH[2]}" != "" ]; then
	DOWN_DIR="${BASH_REMATCH[2]}"
fi

# Check we were given a directory to download to
if [ "$DOWN_DIR" = "" ]; then
	echo "Download directory is required, please specify with the --directory or -d flag"
	exit 1
fi

# Append the repos name to the download path
DOWN_DIR="$DOWN_DIR/$REPO_NAME"

# Check if that directory already exists
if [[ -d "$DOWN_DIR" ]]; then
	# Check its ok to overwrite this directory
	read -r -p "$DOWN_DIR already exists, overwrite? [y/N] " DOWN_DIR_DELETE
	DOWN_DIR_DELETE=${DOWN_DIR_DELETE,,}    # tolower
	if [[ $DOWN_DIR_DELETE =~ ^(yes|y)$ ]]; then
		echo "Deleting $DOWN_DIR"
		rm -rf "$DOWN_DIR"
	else
		exit 0
	fi
fi

"$EXEC_GIT" clone -b "$REPO_BRANCH" --single-branch "$REPO_URL" "$DOWN_DIR"

# Remove the .git directory
rm -rf "$DOWN_DIR/.git"
