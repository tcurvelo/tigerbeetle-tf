#!/bin/sh
set -eu
VERSION=0.16.45
curl -sL \
    https://github.com/tigerbeetle/tigerbeetle/releases/download/${VERSION}/tigerbeetle-x86_64-linux.zip \
    | gzip -d > /usr/local/bin/tigerbeetle

chmod +x /usr/local/bin/tigerbeetle
tigerbeetle version || exit 1
