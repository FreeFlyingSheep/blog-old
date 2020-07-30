#!/bin/bash
# Update the project.
set -e

git pull
git submodule update --remote --merge
