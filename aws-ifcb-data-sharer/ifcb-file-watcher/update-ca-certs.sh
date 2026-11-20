#!/bin/bash
# Refresh the embedded Mozilla CA bundle (from curl.se) and verify its checksum.
# Rebuild the binaries afterwards (./go-build.sh) to pick up the new certificates.
set -euo pipefail
cd "$(dirname "$0")/certs"
curl -fsSLO https://curl.se/ca/cacert.pem.sha256
curl -fsSL -o cacert.pem.new https://curl.se/ca/cacert.pem
expected=$(awk '{print $1}' cacert.pem.sha256)
actual=$(shasum -a 256 cacert.pem.new | awk '{print $1}')
rm cacert.pem.sha256
if [ "$expected" != "$actual" ]; then
  rm cacert.pem.new
  echo "Checksum mismatch, keeping existing cacert.pem" >&2
  exit 1
fi
mv cacert.pem.new cacert.pem
grep -m1 "Certificate data from Mozilla as of" cacert.pem
