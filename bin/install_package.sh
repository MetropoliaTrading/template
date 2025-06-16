#!/usr/bin/env bash
set -e

# Navigate to project root (assumes this script lives in bin/)
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."

# Ensure at least one package is provided
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 package [package ...]" >&2
  exit 1
fi

# Install the provided packages
pip install "$@"

# Freeze current environment to requirements.txt
pip freeze > requirements.txt

echo "requirements.txt has been updated."