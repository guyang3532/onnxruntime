#!/bin/bash
set -ex

mkdir -p /opt/cache/bin
mkdir -p /opt/cache/lib
export PATH="/opt/cache/bin:$PATH"
echo "Downloading sccache binary from S3 repo"
curl --retry 3 https://onnxruntimepackagesint.blob.core.windows.net/bin/sccache -o /opt/cache/bin/sccache
chmod a+x /opt/cache/bin/sccache

function write_sccache_stub() {
  printf "#!/bin/sh\nif [ \$(ps -p \$PPID -o comm=) != sccache ]; then\n  exec sccache $(which $1) \"\$@\"\nelse\n  exec $(which $1) \"\$@\"\nfi" > "/opt/cache/bin/$1"
  chmod a+x "/opt/cache/bin/$1"
}

write_sccache_stub cc
write_sccache_stub c++
write_sccache_stub gcc
write_sccache_stub g++