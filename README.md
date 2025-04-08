# AddressSanitizer Flag Compatibility

This repository analyzes compiler flag compatibility for AddressSanitizer (ASan) and related sanitizer flags across different versions of Clang and GCC compilers.

## Directory Structure

### Data Collection
- `download_clang.sh` - Script to download Clang compiler source files for multiple versions
- `download_gcc.sh` - Script to download GCC compiler source files for multiple versions
- `requests.py` - Python script that tests compiler flag compatibility against the Godbolt Compiler Explorer API
- `requests.ipynb` - Has the output cells on running above script.

### Source Files
- `clang_history/` - Contains source files from different Clang versions
- `gcc_history/` - Contains source files from different GCC versions
- The above history files are output of the download_<clang/gcc> scripts.
- `test.c` - Simple C test file demonstrating AddressSanitizer usage

### Analysis Scripts
- `clang_match.sh` - Script to analyze Clang source files for sanitizer flag support
- `gcc_match.sh` - Script to analyze GCC source files for sanitizer flag support

### Results
- `clang_flag_results/` - Directory containing detailed flag compatibility results for each Clang version
- `gcc_flag_results/` - Directory containing detailed flag compatibility results for each GCC version
- `asan_flag_compatibility_clang.csv` - Comprehensive compatibility matrix for Clang compilers
- `asan_flag_compatibility_gcc.csv` - Comprehensive compatibility matrix for GCC compilers

## Key Sanitizer Flags Analyzed

- `-fsanitize=address` - Enables AddressSanitizer for detecting memory errors
- `-fsanitize=undefined` - Enables UndefinedBehaviorSanitizer
- `-fno-omit-frame-pointer` - Preserves frame pointers for better debugging
- `-fsanitize-recover=address` - Allows program to continue execution after detecting ASan errors
- `-fsanitize-address-use-after-scope` - Detects use of variables after they've gone out of scope
- `-fno-sanitize-recover=all` - Prevents recovery from sanitizer errors
- `-fsanitize=float-divide-by-zero` - Detects floating-point division by zero
- `-fsanitize=float-cast-overflow` - Detects floating-point casting that would cause overflow
- `-fno-sanitize=null` - Disables null pointer dereference checking
- `-fno-sanitize=alignment` - Disables memory alignment checking
