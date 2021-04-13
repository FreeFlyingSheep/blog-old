#!/bin/bash
# Update the project.
set -e

echo "Updating public..."
cd public
git pull --rebase

echo "Updating LoveIt..."
cd ../themes/LoveIt
git pull --rebase

echo "Updating Blog..."
cd ../
git pull --rebase
