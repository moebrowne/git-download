#!/bin/bash

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
	echo "${BASH_REMATCH[@]}"
	if [ "${BASH_REMATCH[1]}" != "" ]; then
		REPO_NAME="${BASH_REMATCH[2]}"
	fi
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

# Append the repos name to the download path
DOWN_DIR="$DOWN_DIR/$REPO_NAME"

"$EXEC_GIT" clone -b "$REPO_BRANCH" --single-branch "$REPO_URL" "$DOWN_DIR"
