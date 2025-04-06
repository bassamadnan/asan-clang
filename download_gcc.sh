#!/bin/bash
mkdir -p gcc_history

GCC_VERSIONS=(
  "4.8.0"
  "4.8.1"
  "4.8.2"
  "4.8.3"
  "4.8.4"
  "4.8.5"
  "4.9.0"
  "4.9.1"
  "4.9.2"
  "4.9.3"
  "4.9.4"
  "5.1.0"
  "5.2.0"
  "5.3.0"
  "5.4.0"
  "6.1.0"
  "6.2.0"
  "6.3.0"
  "6.4.0"
  "6.5.0"
  "7.1.0"
  "7.2.0"
  "7.3.0"
  "7.4.0"
  "7.5.0"
  "8.1.0"
  "8.2.0"
  "8.3.0"
  "8.4.0"
  "8.5.0"
  "9.1.0"
  "9.2.0"
  "9.3.0"
  "9.4.0"
  "9.5.0"
  "10.1.0"
  "10.2.0"
  "10.3.0"
  "10.4.0"
  "10.5.0"
  "11.1.0"
  "11.2.0"
  "11.3.0"
  "11.4.0"
  "12.1.0"
  "12.2.0"
  "12.3.0"
  "13.1.0"
  "13.2.0"
)

download_gcc_files() {
  local version=$1
  local tag="releases/gcc-${version}"
  local common_opt_url="https://gcc.gnu.org/git/?p=gcc.git;a=blob_plain;f=gcc/common.opt;hb=refs/tags/${tag}"
  local sanitizer_url="https://gcc.gnu.org/git/?p=gcc.git;a=blob_plain;f=gcc/sanitizer.cc;hb=refs/tags/${tag}"
  local common2_url="https://gcc.gnu.org/git/?p=gcc.git;a=blob_plain;f=gcc/common/config/i386/i386-common.opt;hb=refs/tags/${tag}"
  local local_dir="gcc_history/${version}"
  
  mkdir -p "$local_dir"
  
  if curl -s -f --retry 3 "$common_opt_url" -o "${local_dir}/common.opt"; then
    :
  else
    echo "error common.opt for ${version}"
  fi
}

for version in "${GCC_VERSIONS[@]}"; do
  download_gcc_files "$version"
done