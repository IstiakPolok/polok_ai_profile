#!/bin/bash

# Exit on any error
set -e

echo "--- Deployment Environment Info ---"
date
pwd
node --version
npm --version

# Ensure .env exists to prevent Flutter asset bundle packaging errors
if [ -n "$GEMINI_API_KEY" ]; then
  echo "GEMINI_API_KEY=$GEMINI_API_KEY" > .env
  echo "Created .env from GEMINI_API_KEY environment variable"
elif [ ! -f ".env" ]; then
  touch .env
  echo "Created empty .env placeholder"
fi

# Install Flutter if not present
if [ ! -d "_flutter" ]; then
  echo "--- Cloning Flutter SDK ---"
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable _flutter
fi

# Use absolute path for Flutter
export PATH="$PWD/_flutter/bin:$PATH"

echo "--- Flutter Version Info ---"
flutter --version

# Enable web support
echo "--- Enabling web support ---"
flutter config --enable-web

# Get dependencies
echo "--- Getting dependencies ---"
flutter pub get

# Build for web
echo "--- Building for web ---"
flutter build web --release --base-href / --dart-define=GEMINI_API_KEY="${GEMINI_API_KEY:-}"

echo "--- Build Complete ---"
ls -la build/web

