#!/bin/bash
FLAGS=(
  "fsanitize="
  "fno-omit-frame-pointer"
  "fsanitize-recover="
  "fsanitize-address-use-after-scope"
)

# Alternative strings/patterns to look for
ALTERNATIVES=(
  "flag_sanitize"
  "flag_omit_frame_pointer"
  "flag_sanitize_recover"
  "flag_sanitize_address_use_after_scope"
)

BASEDIR="gcc_history"
RESULTS_DIR="gcc_flag_results"

# Create results directory
mkdir -p "$RESULTS_DIR"

# Find all version directories
for VERSION_DIR in "$BASEDIR"/*; do
  if [ -d "$VERSION_DIR" ]; then
    VERSION=$(basename "$VERSION_DIR")
    RESULT_FILE="$RESULTS_DIR/$VERSION.txt"
    
    # Create a file for the results
    echo "Version: $VERSION" > "$RESULT_FILE"
    echo "flag_name, present_in_common_opt" >> "$RESULT_FILE"
    
    # Check for each flag
    for i in "${!FLAGS[@]}"; do
      FLAG="${FLAGS[$i]}"
      ALT="${ALTERNATIVES[$i]}"
      
      # Check in common.opt if it exists
      FLAG_PRESENT=0
      OPT_PATH="$VERSION_DIR/common.opt"
      if [ -f "$OPT_PATH" ]; then
        if grep -q "$FLAG" "$OPT_PATH" || grep -q "$ALT" "$OPT_PATH"; then
          FLAG_PRESENT=1
        fi
      fi
      
      echo "$FLAG, $FLAG_PRESENT" >> "$RESULT_FILE"
    done
    
    echo "Processed version $VERSION"
  fi
done

echo "Results saved to $RESULTS_DIR directory"