#!/bin/bash
# Update the project.
set -e

git pull --rebase

cd public
git pull --rebase

cd ../themes/LoveIt
git pull --rebase
