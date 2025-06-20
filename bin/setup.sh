#!/usr/bin/env bash
set -e

# Parse optional mode flag
APP_ENV=""
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -m | --mode ) shift; APP_ENV=$1 ;;
  -?* ) echo "Unknown option: $1" >&2; exit 1 ;;
esac; shift; done
if [[ "$1" == "--" ]]; then shift; fi

# Export APP_ENV so it's available for subprocesses
export APP_ENV

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

# Set up the .env file (use SQLite in non-production environments)
if [[ -z "$APP_ENV" || "$APP_ENV" != "production" ]]; then
  if [ ! -f .env ]; then
    cp .env.sample .env
    # Insert default SQLite URL into .env
    sed -i.bak -E 's|^DATABASE_URL=.*|DATABASE_URL=postgresql://devuser:devpass@db:5432/devdb|' .env && rm .env.bak
    echo ".env file created from .env.sample with default SQLite configuration."
  else
    echo ".env file already exists."
  fi
  # Load environment variables from .env
  echo "Loading environment variables from .env..."
  set -o allexport
  # shellcheck disable=SC1090
  source .env
  set +o allexport
  echo "Environment variables loaded."
else
  echo "Production environment detected; skipping .env setup and load."
fi

echo "✅ Setup complete."
