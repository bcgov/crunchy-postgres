#!/usr/bin/env bash
set -xeuo pipefail;

version="8.16.0";
releases_api="https://api.github.com/repositories/119190187/releases/tags/v${version}";
releases_json="$(curl -s ${releases_api})";

case "$OSTYPE" in
  darwin*)  arch="darwin_x64" ;; # arm detection? I give up
  linux*)   arch="linux_x64" ;;
  solaris*) echo "Error: Solaris is not supported"; exit 1; ;;
  bsd*)     echo "Error: BSD is not supported"; exit 1; ;;
  msys*)    echo "Error: Windows is not supported"; exit 1; ;;
  cygwin*)  echo "Error: Windows is still not supported"; exit 1; ;;
  *)        echo "Error: unknown: $OSTYPE – definitely not supported"; exit 1; ;;
esac

# download the specified release
download_url=$(echo "${releases_json}" | jq -r ".assets[] | select(.name | contains(\"${arch}\")) | .browser_download_url");
wget "${download_url}";

# validate checksum
download_url=$(echo "${releases_json}" | jq -r ".assets[] | select(.name | contains(\"checksums\")) | .browser_download_url");
wget "${download_url}";
sed -i.bak -n "/${arch}/p" gitleaks_${version}_checksums.txt
shasum -a 256 "gitleaks_${version}_checksums.txt" --check;

# extract to current working directory
tar -zxvf "gitleaks_${version}_${arch}.tar.gz" gitleaks;

# check version
if [[ "$(./gitleaks version)" != "${version}" ]]; then
  echo "Somehow we installed the wrong version...";
  exit 1;
fi

# cleanup
rm gitleaks_*;

exit 0;
