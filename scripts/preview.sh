#!/bin/bash
# Preview the website.
set -e

# Since the theme use .Scratch in Hugo to implement some features,
# it is highly recommended that you add --disableFastRender parameter
# to hugo server command for the live preview of the page you are editing.
# 
# Due to limitations in the local development environment,
# the comment system, CDN and fingerprint will not
# be enabled in the development environment.
# You could enable these features with hugo serve -e production.
hugo serve --disableFastRender -e production
