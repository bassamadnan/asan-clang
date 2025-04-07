#!/bin/bash

# Flags to check for
FLAGS=(
  "fsanitize=address"
  "fno-omit-frame-pointer"
  "fsanitize-recover"
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

# Alternative strings to look for
ALTERNATIVES=(
  "SanitizerKind::Address|Address"
  "flag_omit_frame_pointer|frame_pointer"
  "RecoverableKinds|SanitizerKind::Address.*recover"
  "AsanUseAfterScope|flag_sanitize_address_use_after_scope"
  "SanitizerKind::Undefined|Undefined"
  "fno-sanitize-recover|RecoverableKinds"
  "float.*divide.*zero|FloatDivideByZero"
  "float.*cast.*overflow|FloatCastOverflow"
  "Null.*sanitizer|SanitizerKind::Null"
  "Alignment.*sanitizer|SanitizerKind::Alignment"
  "Wall"
  "Wextra|W_Group"
)

# Combined flags that need to be used together
COMBINED_FLAGS=(
  "fsanitize-address-use-after-scope:fsanitize=address"
  "fsanitize=float-divide-by-zero:fsanitize=undefined"
  "fsanitize=float-cast-overflow:fsanitize=undefined"
)

BASEDIR="clang_history"
RESULTS_DIR="clang_flag_results"

# Create results directory
mkdir -p "$RESULTS_DIR"

# Find all version directories
for VERSION_DIR in "$BASEDIR"/*; do
  if [ -d "$VERSION_DIR" ]; then
    VERSION=$(basename "$VERSION_DIR")
    RESULT_FILE="$RESULTS_DIR/$VERSION.txt"
    
    # Create a file for the results
    echo "Version: $VERSION" > "$RESULT_FILE"
    echo "flag_name, options_present, sanitizer_present, notes" >> "$RESULT_FILE"
    
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
      echo "$FLAG, $OPTIONS_PRESENT, $SANITIZER_PRESENT, $NOTES" >> "$RESULT_FILE"
    done
    
    echo "Processed version $VERSION"
  fi
done

echo "Results saved to $RESULTS_DIR directory"