#!/bin/bash
# Deploy updates to GitHub.
set -e

echo "Deploying updates to GitHub..."

cd public
git rm -rf . > /dev/null

cd ..
hugo

cd public
git add .

msg="Rebuild site on `date '+%x %X'`"
if [ -n "$*" ]; then
    msg="$*"
fi
git commit -m "$msg"

git push origin master

cd ..
git add .
git commit -m "$msg"
git push --recurse-submodules=check origin master
