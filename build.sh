# Install Flutter if not present
if [ ! -d "_flutter" ]; then
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable _flutter
fi

# Use absolute path for Flutter
export PATH="$PWD/_flutter/bin:$PATH"

# Print environment for debugging
printenv

# Verify Flutter installation
flutter --version
flutter doctor

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Build for web
flutter build web --release --web-renderer html
