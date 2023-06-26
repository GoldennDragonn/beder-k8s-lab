#!/bin/bash

# Prompt user for commit message
echo "Enter commit message:"
read commit_message

# Add all files to the staging area
git add .

# Commit changes with the provided message
git commit -m "$commit_message"

# Push changes to the remote repository
git push
