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
  docker run --rm -t \
    -v "$WORKDIR":/app \
    -u $(id -u):$(id -g) \
    lennihein/hostlist-compiler \
    hostlist-compiler -c "lostad_${module}.json" -o "lostad_${module}.txt"


  
  sort -o "lostad_${module}.txt"{,}
  sed -i '/^$/d' "lostad_${module}.txt"
  sed -i '/^!/d' "lostad_${module}.txt"

  # Metadata
  echo -e "!\n! Expires: 1 day\n! Name: LostAd ${module^}\n[Adblock Plus 2.0]" > "lostad_${module}.txt.tmp"
  cat "lostad_${module}.txt" >> "lostad_${module}.txt.tmp"
  mv "lostad_${module}.txt.tmp" "lostad_${module}.txt"
done

# Combine full list (everything but DNS)
echo "[+] Building lostad_full.txt..."
docker run --rm -t \
  -v "$WORKDIR":/app \
  -u $(id -u):$(id -g) \
  lennihein/hostlist-compiler \
  hostlist-compiler -c "lostad_full.json" -o "lostad_full.txt"

# Metadata for Full List
echo -e "!\n! Expires: 1 day\n! Name: LostAd Full\n[Adblock Plus 2.0]" > lostad_full.txt.tmp
cat lostad_full.txt >> lostad_full.txt.tmp
mv lostad_full.txt.tmp lostad_full.txt

# Copy to Caddy output dir
echo "[+] Deploying to $OUTPUT_DIR..."
cp lostad_*.txt "$OUTPUT_DIR"

# Optional: Push to GitHub mirror
# git stage lostad_*.txt
# git commit -m "Build $(timestamp) UTC"
# git push

echo "[✓] Done! Built and deployed at $(timestamp) UTC"
