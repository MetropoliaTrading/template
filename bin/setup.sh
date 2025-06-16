#!/usr/bin/env bash
set -e

# Navigate to project root (assumes this script lives in bin/)
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."

# Upgrade pip and install all dependencies
pip install --upgrade pip
pip install -r requirements.txt

echo "✅ Setup complete."
