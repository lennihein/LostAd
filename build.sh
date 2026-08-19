#!/bin/bash

set -e

timestamp() {
  date +"%Y/%m/%d %H:%M:%S"
}

# Define working and output directories
WORKDIR="$(pwd)"
OUTPUT_DIR="${OUTPUT_DIR:-$WORKDIR/dist}"

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

# Determine compiler command (global binary or npx fallback)
if command -v hostlist-compiler >/dev/null 2>&1; then
  COMPILER_CMD="hostlist-compiler"
else
  COMPILER_CMD="npx --yes @adguard/hostlist-compiler"
fi

echo "[+] Using compiler: $COMPILER_CMD"

# Build each module
for module in "${MODULES[@]}"; do
  echo "[+] Compiling lostad_${module}.txt..."
  $COMPILER_CMD -c "lostad_${module}.json" -o "lostad_${module}.txt"
done

# Build full list (depends on the individual compiled txt modules)
echo "[+] Compiling lostad_full.txt..."
$COMPILER_CMD -c "lostad_full.json" -o "lostad_full.txt"

# Clean metadata and perform operations for all lists (modules + full list)
for module in "${MODULES[@]}" full; do
  echo "[+] Cleaning and finalizing lostad_${module}.txt..."
  sort -o "lostad_${module}.txt"{,}
  sed -i '/^[[:space:]]*$/d' "lostad_${module}.txt"
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

# Copy artifacts to output dir
echo "[+] Deploying to $OUTPUT_DIR..."
cp lostad_*.txt "$OUTPUT_DIR"/
cp install.html "$OUTPUT_DIR"/
cp install.html "$OUTPUT_DIR"/index.html
if [ -f CNAME ]; then
  cp CNAME "$OUTPUT_DIR"/
fi

# Clean up working directory .txt files if OUTPUT_DIR is different from WORKDIR
if [ "$OUTPUT_DIR" != "$WORKDIR" ]; then
  rm -f lostad_*.txt
fi

echo "[✓] Done! Built and ready in $OUTPUT_DIR at $(timestamp) UTC"
