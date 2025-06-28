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

- path: /tmp/install.sh
  permissions: '0755'
  content: |
    ${install}

runcmd:
  - [ /tmp/install.sh ]
  - [ systemctl, daemon-reload ]
  - [ systemctl, enable, tigerbeetle.service ]
  - [ systemctl, start, tigerbeetle.service ]
