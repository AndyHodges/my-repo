#!/bin/bash
set -ex

# Convenience workspace directory for later use
WORKSPACE_DIR=$(pwd)

##
## Python project configuration & deps
##

# Change some Poetry settings to better deal with working in a container
poetry config cache-dir ${WORKSPACE_DIR}/.cache
poetry config virtualenvs.in-project true

# Now install all dependencies
poetry install

##
## Node and npm project configuration & deps
##
npm install

##
## Pre-Commit Install
##
${WORKSPACE_DIR}/.venv/bin/pre-commit install

echo "Done!"