#!/bin/bash

# Flags to check for
FLAGS=(
  "fsanitize=address"
  "fno-omit-frame-pointer"
  "fsanitize-recover="
  "fsanitize-address-use-after-scope"
  "fsanitize=undefined"
  "fno-sanitize-recover=all"
  "fsanitize=float-divide-by-zero"
  "fsanitize=float-cast-overflow"
  "fno-sanitize=null"
  "fno-sanitize=alignment"
  "Wall"
  "Wextra"
)

# Alternative strings/patterns to look for
ALTERNATIVES=(
  "flag_sanitize|SANITIZE_ADDRESS"
  "flag_omit_frame_pointer"
  "flag_sanitize_recover"
  "flag_sanitize_address_use_after_scope"
  "flag_sanitize|SANITIZE_UNDEFINED"
  "fno-sanitize-recover"
  "float.*divide.*zero"
  "float.*cast.*overflow"
  "sanitize.*null"
  "sanitize.*alignment"
  "Wall"
  "Wextra|W_Group"
)

# Combined flags that need to be used together
COMBINED_FLAGS=(
  "fsanitize-address-use-after-scope:fsanitize=address"
  "fsanitize=float-divide-by-zero:fsanitize=undefined"
  "fsanitize=float-cast-overflow:fsanitize=undefined"
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
    echo "flag_name, present_in_common_opt, notes" >> "$RESULT_FILE"
    
    # Check for each flag
    for i in "${!FLAGS[@]}"; do
      FLAG="${FLAGS[$i]}"
      ALT="${ALTERNATIVES[$i]}"
      NOTES=""
      
      # Check for combined flag dependencies
      for COMBINED in "${COMBINED_FLAGS[@]}"; do
        IFS=':' read -r CFLAG DEPENDENCY <<< "$COMBINED"
        if [[ "$FLAG" == "$CFLAG" ]]; then
          NOTES="Requires $DEPENDENCY to work properly"
          break
        fi
      done
      
      # Check in common.opt if it exists
      FLAG_PRESENT=0
      OPT_PATH="$VERSION_DIR/common.opt"
      if [ -f "$OPT_PATH" ]; then
        if grep -q "$FLAG" "$OPT_PATH" || grep -Eq "$ALT" "$OPT_PATH"; then
          FLAG_PRESENT=1
        fi
      fi
      
      echo "$FLAG, $FLAG_PRESENT, $NOTES" >> "$RESULT_FILE"
    done
    
    echo "Processed version $VERSION"
  fi
done

echo "Results saved to $RESULTS_DIR directory"