#!/bin/bash
# Update the project.
set -e

echo "Update public..."
cd public
git pull --rebase

echo "Update LoveIt..."
cd ../themes/LoveIt
git pull --rebase

echo "Update Blog..."
cd ../
git pull --rebase
