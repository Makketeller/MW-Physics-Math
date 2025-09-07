#!/usr/bin/env bash
set -e

CACHE_DIR="${QUARTO_CACHE_DIR:-/opt/build/cache/quarto}"
QUARTO_DIR="${CACHE_DIR}/quarto-${QUARTO_VERSION}"
QUARTO_BIN="${QUARTO_DIR}/usr/bin/quarto"

if [ -x "$QUARTO_BIN" ]; then
  echo "✅ Using cached Quarto $QUARTO_VERSION"
else
  echo "🔽 Installing Quarto $QUARTO_VERSION ..."
  mkdir -p "$CACHE_DIR"

  URL="https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb"

  if ! wget -q "$URL" -O /tmp/quarto.deb; then
    echo "❌ Failed to download Quarto from $URL"
    exit 1
  fi

  mkdir -p "$QUARTO_DIR"
  if ! dpkg -x /tmp/quarto.deb "$QUARTO_DIR"; then
    echo "❌ Failed to extract Quarto .deb"
    exit 1
  fi
fi

# ✅ Make sure Quarto is on PATH
export PATH="${QUARTO_DIR}/usr/bin:$PATH"

echo "✅ Quarto version: $(quarto --version)"

# Run the actual build here, so PATH stays valid
quarto render