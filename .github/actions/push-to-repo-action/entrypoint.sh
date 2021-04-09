#!/bin/sh -l

# Based on cpina/github-action-push-to-another-repository
# https://github.com/cpina/github-action-push-to-another-repository

set -e  # if a command fails it stops the execution
set -u  # script fails if trying to access to an undefined variable

SOURCE_DIR="$1"  # Source directory name in the source repository

USER_NAME="manuelemacchia"
USER_EMAIL="macchiamanuele@gmail.com"

SOURCE_REPOSITORY="website"
DESTINATION_REPOSITORY="manuelemacchia.github.io"  # Destination repository name

echo "Configuring"
git config --global user.email "$USER_EMAIL"
git config --global user.name "$USER_NAME"

echo "Cloning source repository"
SOURCE_CLONE_DIR=$(mktemp -d)
git clone --single-branch --branch main "https://$API_TOKEN_GITHUB@github.com/$USER_NAME/$SOURCE_REPOSITORY.git" "$SOURCE_CLONE_DIR"
ls -la "$SOURCE_CLONE_DIR"

echo "Cloning destination repository"
DESTINATION_CLONE_DIR=$(mktemp -d)
git clone --single-branch --branch main "https://$API_TOKEN_GITHUB@github.com/$USER_NAME/$DESTINATION_REPOSITORY.git" "$DESTINATION_CLONE_DIR"
ls -la "$DESTINATION_CLONE_DIR"

echo "Cleaning destination repository"
rm -rf "$DESTINATION_CLONE_DIR"/*

echo "Copying contents from source directory to destination repository"
cp -ra "$SOURCE_CLONE_DIR"/"$SOURCE_DIR"/. "$DESTINATION_CLONE_DIR"
cd "$DESTINATION_CLONE_DIR"

echo "Files that will be pushed"
ls -la

echo "Adding git commit"
git add .
git status

git diff-index --quiet HEAD || git commit --message "Update site"

git push origin
