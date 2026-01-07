#!/bin/bash

# Exit on any error
set -e

echo "--- Deployment Environment Info ---"
date
pwd
node --version
npm --version

# Install Flutter if not present
if [ ! -d "_flutter" ]; then
  echo "--- Cloning Flutter ---"
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
flutter build web --release --web-renderer html --base-href /

echo "--- Build Complete ---"
ls -la build/web
