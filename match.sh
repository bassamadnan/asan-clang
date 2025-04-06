#!/bin/bash

# Flags to check for
FLAGS=(
  "fsanitize=address"
  "fno-omit-frame-pointer"
  "fsanitize-recover=address"
  "fsanitize-address-use-after-scope"
)

# Alternative strings to look for
ALTERNATIVES=(
  "SanitizerKind::Address"
  "fno-omit-frame-pointer"
  "SanitizerKind::Address.*recover"
  "AsanUseAfterScope"
)

BASEDIR="clang_history"
RESULTS_DIR="flag_results"

# Create results directory
mkdir -p "$RESULTS_DIR"

# Find all version directories
for VERSION_DIR in "$BASEDIR"/*; do
  if [ -d "$VERSION_DIR" ]; then
    VERSION=$(basename "$VERSION_DIR")
    RESULT_FILE="$RESULTS_DIR/$VERSION.txt"
    
    # Create a file for the results
    echo "Version: $VERSION" > "$RESULT_FILE"
    echo "flag_name, options_present, sanitizer_present" >> "$RESULT_FILE"
    
    # Check for each flag
    for i in "${!FLAGS[@]}"; do
      FLAG="${FLAGS[$i]}"
      ALT="${ALTERNATIVES[$i]}"
      
      # Check in Options.td if it exists
      OPTIONS_PRESENT=0
      OPTIONS_PATH="$VERSION_DIR/Options.td"
      if [ -f "$OPTIONS_PATH" ]; then
        if grep -q "$FLAG" "$OPTIONS_PATH" || grep -Eq "$ALT" "$OPTIONS_PATH"; then
          OPTIONS_PRESENT=1
        fi
      fi
      
      # Check in SanitizerArgs.cpp if it exists
      SANITIZER_PRESENT=0
      SANITIZER_PATH="$VERSION_DIR/SanitizerArgs.cpp"
      if [ -f "$SANITIZER_PATH" ]; then
        if grep -q "$FLAG" "$SANITIZER_PATH" || grep -Eq "$ALT" "$SANITIZER_PATH"; then
          SANITIZER_PRESENT=1
        fi
      fi
      
      # Write results to file
      echo "$FLAG, $OPTIONS_PRESENT, $SANITIZER_PRESENT" >> "$RESULT_FILE"
    done
    
    echo "Processed version $VERSION"
  fi
done

echo "Results saved to $RESULTS_DIR directory"