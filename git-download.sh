#!/bin/bash

# Config

# Git executable
EXEC_GIT="/usr/bin/git"

regexArgType=' -(-repo|r) ([^ ]+) '
[[ $args =~ $regexArgType ]]
if [ "${BASH_REMATCH[2]}" != "" ]; then
	REPO_URL="${BASH_REMATCH[2]}"
else
	REPO_URL="rsa"
fi

regexArgType=' -(-branch|b) ([^ ]+) '
[[ $args =~ $regexArgType ]]
if [ "${BASH_REMATCH[2]}" != "" ]; then
	REPO_BRANCH="${BASH_REMATCH[2]}"
else
	REPO_BRANCH="master"
fi
