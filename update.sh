#!/bin/bash
# Update the project.
set -e

git pull --rebase
git submodule update --remote --rebase
