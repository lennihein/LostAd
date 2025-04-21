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

# Build each module
for module in "${MODULES[@]}"; do
  echo "[+] Building lostad_$module.txt..."
  docker run --rm -t -v "$WORKDIR":/app lennihein/hostlist-compiler \
    hostlist-compiler -c "lostad_${module}.json" -o "lostad_${module}.txt"
  
  sort -o "lostad_${module}.txt"{,}
  sed -i '/^$/d' "lostad_${module}.txt"
  sed -i '/^!/d' "lostad_${module}.txt"

  # Metadata
  echo -e "!\n! Expires: 1 day\n! Name: LostAd ${module^}\n[Adblock Plus 2.0]\n$(cat lostad_${module}.txt)" > "lostad_${module}.txt"
done

# Combine full list (everything but DNS)
echo "[+] Combining full list..."
cat lostad_core.txt \
    lostad_social.txt \
    lostad_cookies.txt \
    lostad_tracking.txt \
    lostad_annoyances.txt \
    lostad_german.txt > lostad_full.txt

# Add metadata
echo -e "!\n! Expires: 1 day\n! Name: LostAd Full\n[Adblock Plus 2.0]\n$(cat lostad_full.txt)" > lostad_full.txt

# Generate lean version (first 250k lines)
echo "[+] Generating lean list..."
head -n 250000 lostad_full.txt > lostad_lean.txt
echo -e "!\n! Expires: 1 day\n! Name: LostAd Lean\n[Adblock Plus 2.0]\n$(cat lostad_lean.txt)" > lostad_lean.txt

# Copy to Caddy output dir
echo "[+] Deploying to $OUTPUT_DIR..."
cp lostad_*.txt "$OUTPUT_DIR"

# Optional: Push to GitHub mirror
# git stage lostad_*.txt
# git commit -m "Build $(timestamp) UTC"
# git push

echo "[✓] Done! Built and deployed at $(timestamp) UTC"
