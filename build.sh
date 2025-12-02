#!/bin/bash

# Install Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable _flutter
export PATH="$PATH:_flutter/bin"

# Verify Flutter installation
flutter --version

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Build for web
flutter build web --release --web-renderer html

# Move build output to root for Vercel
mv build/web/* .
