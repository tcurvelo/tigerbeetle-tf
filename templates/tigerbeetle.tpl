#cloud-config
write_files:
- path: /etc/systemd/system/tigerbeetle.service
  permissions: '0644'
  content: |
    [Unit]
    Description=TigerBeetle Replica
    Documentation=https://docs.tigerbeetle.com/
    After=network-online.target
    Wants=network-online.target systemd-networkd-wait-online.service

    [Service]
    AmbientCapabilities=CAP_IPC_LOCK

    Environment=TIGERBEETLE_CACHE_GRID_SIZE=1GiB
    Environment=TIGERBEETLE_ADDRESSES=3001
    Environment=TIGERBEETLE_REPLICA_COUNT=1
    Environment=TIGERBEETLE_REPLICA_INDEX=0
    Environment=TIGERBEETLE_CLUSTER_ID=0
    Environment=TIGERBEETLE_DATA_FILE=%S/tigerbeetle/0_0.tigerbeetle

    DevicePolicy=closed
    DynamicUser=true
    LockPersonality=true
    ProtectClock=true
    ProtectControlGroups=true
    ProtectHome=true
    ProtectHostname=true
    ProtectKernelLogs=true
    ProtectKernelModules=true
    ProtectKernelTunables=true
    ProtectProc=noaccess
    ProtectSystem=strict
    RestrictAddressFamilies=AF_INET AF_INET6
    RestrictNamespaces=true
    RestrictRealtime=true
    RestrictSUIDSGID=true

    StateDirectory=tigerbeetle
    StateDirectoryMode=700

    Type=exec
    ExecStartPre=/usr/local/bin/tigerbeetle-pre-start.sh
    ExecStart=/usr/local/bin/tigerbeetle start --cache-grid=$${TIGERBEETLE_CACHE_GRID_SIZE} --addresses=$${TIGERBEETLE_ADDRESSES} $${TIGERBEETLE_DATA_FILE}

    [Install]
    WantedBy=multi-user.target

- path: /usr/local/bin/tigerbeetle-pre-start.sh
  permissions: '0755'
  content: |
    #!/bin/sh
    set -eu

    if ! test -e "$${TIGERBEETLE_DATA_FILE}"; then
      /usr/local/bin/tigerbeetle format --cluster="$${TIGERBEETLE_CLUSTER_ID}" --replica="$${TIGERBEETLE_REPLICA_INDEX}" --replica-count="$${TIGERBEETLE_REPLICA_COUNT}" "$${TIGERBEETLE_DATA_FILE}"
    fi

- path: /tmp/install.sh
  permissions: '0755'
  content: |
    #!/bin/sh
    set -eu
    VERSION=0.16.45
    curl -sL \
        https://github.com/tigerbeetle/tigerbeetle/releases/download/$${VERSION}/tigerbeetle-x86_64-linux.zip \
        | gzip -d > /usr/local/bin/tigerbeetle

    chmod +x /usr/local/bin/tigerbeetle
    tigerbeetle version || exit 1

runcmd:
  - [ /tmp/install.sh ]
  - [ systemctl, daemon-reload ]
  - [ systemctl, enable, tigerbeetle.service ]
  - [ systemctl, start, tigerbeetle.service ]
