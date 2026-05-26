#!/usr/bin/env bash
set -euo pipefail

export FLUTTER_HOME="${FLUTTER_HOME:-$HOME/flutter}"
export PATH="$FLUTTER_HOME/bin:$PATH"

if ! command -v flutter >/dev/null 2>&1; then
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_HOME"
fi

flutter config --enable-web
flutter pub get
flutter build web --release --base-href /
