#!/bin/bash

# Usage function
usage() {
    echo "Usage: $0 -r|--repo <repository_url> [-b|--branch <branch_name>] -d|--directory <download_directory>"
    echo "  -r, --repo        The URL of the repository to download"
    echo "  -b, --branch      The branch to download [default: master]"
    echo "  -d, --directory   The directory where the branch should be downloaded"
    exit 1
}

# Check for required dependencies
if ! command -v git &> /dev/null; then
    echo "Error: Git is not installed or not available in the PATH."
    exit 1
fi

# Default values
REPO_BRANCH="master"
REPO_URL=""
DOWN_DIR=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--repo)
            REPO_URL="$2"
            shift 2
            ;;
        -b|--branch)
            REPO_BRANCH="$2"
            shift 2
            ;;
        -d|--directory)
            DOWN_DIR="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate inputs
if [[ -z "$REPO_URL" ]]; then
    echo "Error: Repository URL is required. Use -r or --repo to specify."
    usage
fi

if [[ -z "$DOWN_DIR" ]]; then
    echo "Error: Download directory is required. Use -d or --directory to specify."
    usage
fi

# Extract repository name from the URL
REPO_NAME=$(basename -s .git "$REPO_URL")
DOWN_DIR="$DOWN_DIR/$REPO_NAME"

# Confirm overwrite if the directory exists
if [[ -d "$DOWN_DIR" ]]; then
    read -r -p "$DOWN_DIR already exists. Overwrite? [y/N] " response
    response=${response,,} # Convert to lowercase
    if [[ "$response" =~ ^(yes|y)$ ]]; then
        echo "Deleting $DOWN_DIR"
        rm -rf "$DOWN_DIR"
    else
        echo "Aborting."
        exit 1
    fi
fi

# Clone the repository
echo "Cloning branch '$REPO_BRANCH' of '$REPO_URL' into '$DOWN_DIR'..."
if ! git clone -b "$REPO_BRANCH" --single-branch "$REPO_URL" "$DOWN_DIR"; then
    echo "Error: Failed to clone repository."
    exit 1
fi

# Remove .git directory if it exists
if [[ -d "$DOWN_DIR/.git" ]]; then
    echo "Removing .git directory..."
    rm -rf "$DOWN_DIR/.git"
fi

echo "Download completed successfully."
