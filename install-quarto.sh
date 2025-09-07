#!/usr/bin/env bash
set -e

CACHE_DIR="${QUARTO_CACHE_DIR:-/opt/build/cache/quarto}"
QUARTO_DIR="${CACHE_DIR}/quarto-${QUARTO_VERSION}"

if [ -x "${QUARTO_DIR}/opt/quarto/bin/quarto" ]; then
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

# ✅ Quarto lives under opt/quarto/bin
export PATH="${QUARTO_DIR}/opt/quarto/bin:$PATH"

echo "✅ Quarto version: $(quarto --version)"

# Run the actual site build
quarto render
