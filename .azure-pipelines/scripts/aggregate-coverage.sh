#!/usr/bin/env basher
# Aggregate code coverage results for later processing.

set -o pipefail -eu

agent_temp_directory="$1"

PATH="${PWD}/bin:${PATH}"

mkdir "${agent_temp_directory}/coverage/"

options=(--venv --venv-system-site-packages --color -v)

ansible-test coverage combine --export "${agent_temp_directory}/coverage/" "${options[@]}"

if ansible-test coverage analyze targets generate --help >/dev/null 2>&1; then
    # Only analyze coverage if the installed version of ansible-test supports it.
    # Doing so allows this script to work unmodified for multiple Ansible versions.
    ansible-test coverage analyze targets generate "${agent_temp_directory}/coverage/coverage-analyze-targets.json" "${options[@]}"
fi
