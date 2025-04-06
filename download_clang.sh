#!/bin/bash
mkdir -p clang_history

VERSIONS=(
  "3.0.0"
  "3.1"
  "3.2"
  "3.3"
  "3.4.1"
  "3.5"
  "3.5.1"
  "3.5.2"
  "3.6"
  "3.7"
  "3.7.1"
  "3.8"
  "3.8.1"
  "3.9.0"
  "3.9.1"
  "4.0.0"
  "4.0.1"
  "5.0.0"
  "5.0.1"
  "5.0.2"
  "6.0.0"
  "6.0.1"
  "7.0.0"
  "7.0.1"
  "7.1.0"
  "8.0.0"
  "8.0.1"
  "9.0.0"
  "9.0.1"
  "10.0.0"
  "10.0.1"
  "11.0.0"
  "11.0.1"
  "12.0.0"
  "12.0.1"
  "13.0.0"
  "13.0.1"
  "14.0.0"
  "15.0.0"
  "16.0.0"
  "17.0.1"
  "18.1.0"
  "19.1.0"
  "20.1.0"
)
download_files() {
 local version=$1
 local tag_prefix="llvmorg-"
 local tag="${tag_prefix}${version}"
 local options_url="https://raw.githubusercontent.com/llvm/llvm-project/${tag}/clang/include/clang/Driver/Options.td"
 local sanitizer_url="https://raw.githubusercontent.com/llvm/llvm-project/${tag}/clang/lib/Driver/SanitizerArgs.cpp"
 local version_dir="clang_history/${version}"
 
 mkdir -p "$version_dir"
 
 if curl -s -f --retry 3 "$options_url" -o "${version_dir}/Options.td"; then
   :
 else
   echo "error Options.td"
 fi
 
 if curl -s -f --retry 3 "$sanitizer_url" -o "${version_dir}/SanitizerArgs.cpp"; then
   :
 else
   echo "error SanitizerArgs.cpp"
 fi
}

for version in "${VERSIONS[@]}"; do
 download_files "$version"
done