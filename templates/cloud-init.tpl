#cloud-config
write_files:
- path: /etc/systemd/system/tigerbeetle.service
  permissions: '0644'
  content: |
    ${service}

- path: /usr/local/bin/tigerbeetle-pre-start.sh
  permissions: '0755'
  content: |
    ${pre_start}

- path: /etc/systemd/system/statsd-exporter.service
  permissions: '0644'
  content: |
    ${statsd}

- path: /tmp/install.sh
  permissions: '0755'
  content: |
    ${install}

runcmd:
  - [ /tmp/install.sh ]
  - [ systemctl, daemon-reload ]
  - [ systemctl, enable, tigerbeetle.service ]
  - [ systemctl, enable, statsd-exporter.service ]
  - [ systemctl, start, statsd-exporter.service ]
  - [ systemctl, start, tigerbeetle.service ]

output: { all: '| tee -a /var/log/cloud-init-output.log' }
