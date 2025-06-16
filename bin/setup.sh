#!/usr/bin/env bash
set -e

# Navigate to project root (assumes this script lives in bin/)
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."

# Allow all the bash scripts in bin/ to be executable
chmod +x bin/*.sh

# Create a virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
  python3 -m venv .venv
  echo "Virtual environment created."
else
  echo "Virtual environment already exists."
fi

# Activate the virtual environment
source .venv/bin/activate

# Upgrade pip in the virtual environment
pip install --upgrade pip

# Ensure requirements.txt exists
if [ ! -f requirements.txt ]; then
  echo "requirements.txt not found. Creating a new one."
  touch requirements.txt
else
  echo "requirements.txt found."
fi

# Install the required packages
pip install -r requirements.txt

echo "✅ Setup complete."
