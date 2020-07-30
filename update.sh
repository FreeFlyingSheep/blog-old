#!/bin/bash
# Update the project.
set -e

git pull --recurse-submodules

cd public
git checkout master

cd ../themes/LoveIt
git checkout master

cd ../..
git submodule update --remote --merge
