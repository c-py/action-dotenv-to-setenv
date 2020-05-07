#!/bin/sh -l

DOTENV_FILE=$1
[ -f "${DOTENV_FILE}" ] || { echo "${DOTENV_FILE} must be a valid file" >&2; exit 1; }

export DOTENV_FILE
source /dotenv.sh
