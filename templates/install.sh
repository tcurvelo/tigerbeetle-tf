#!/bin/sh
set -eu

# Install TigerBeetle
TIGERBEETLE_VERSION=0.16.45
curl -sL \
    https://github.com/tigerbeetle/tigerbeetle/releases/download/${TIGERBEETLE_VERSION}/tigerbeetle-x86_64-linux.zip -o /tmp/tigerbeetle.zip ;
gzip -d < /tmp/tigerbeetle.zip > /usr/local/bin/tigerbeetle

chmod +x /usr/local/bin/tigerbeetle
tigerbeetle version || exit 1


# Install statsd_exporter
STATSD_EXPORTER_VERSION=0.28.0
curl -sL \
    https://github.com/prometheus/statsd_exporter/releases/download/v${STATSD_EXPORTER_VERSION}/statsd_exporter-${STATSD_EXPORTER_VERSION}.linux-amd64.tar.gz \
    -o /tmp/statsd_exporter.tar.gz;
tar -xvf /tmp/statsd_exporter.tar.gz -C /tmp/
mv /tmp/statsd_exporter-*/statsd_exporter /usr/local/bin/
chmod +x /usr/local/bin/statsd_exporter

statsd_exporter --version || exit 1
