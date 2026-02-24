#!/bin/bash

set -e

timestamp() {
  date +"%Y/%m/%d %H:%M:%S"
}

# Define working and output directories
WORKDIR="$(pwd)"
OUTPUT_DIR="/data/lostad"

# Ensure output dir exists
mkdir -p "$OUTPUT_DIR"

# List of modules to build
MODULES=(
  core
  social
  cookies
  tracking
  annoyances
  german
  dns
)

# Build all modules and full list in a single container boot
echo "[+] Building all modules and full list..."
docker run --rm -t \
  -v "$WORKDIR":/app \
  -u $(id -u):$(id -g) \
  lennihein/hostlist-compiler \
  sh -c 'for module in core social cookies tracking annoyances german dns full; do
    echo "[+] Compiling lostad_${module}.txt..."
    hostlist-compiler -c "lostad_${module}.json" -o "lostad_${module}.txt"
  done'

# Clean metadata and perform operations for all lists (modules + full list)
for module in "${MODULES[@]}" full; do
  echo "[+] Cleaning and finalizing lostad_${module}.txt..."
  sort -o "lostad_${module}.txt"{,}
  sed -i '/^$/d' "lostad_${module}.txt"
  sed -i '/^!/d' "lostad_${module}.txt"
  sed -i '/^\[Adblock/d' "lostad_${module}.txt"

  # DNS Cleanup (Remove cosmetic and modifier rules from imported files like customs)
  if [ "$module" = "dns" ]; then
    sed -i '/#/d' "lostad_${module}.txt"
    sed -i '/\$/d' "lostad_${module}.txt"
    sed -i '/=/d' "lostad_${module}.txt"
  fi

  # Metadata Insertion
  sed -i "1i [Adblock Plus 2.0]\n! Title: LostAd ${module^}\n! Expires: 1 days" "lostad_${module}.txt"
done

# Copy to Caddy output dir
echo "[+] Deploying to $OUTPUT_DIR..."
cp lostad_*.txt install.html "$OUTPUT_DIR"

echo "[✓] Done! Built and deployed at $(timestamp) UTC"
