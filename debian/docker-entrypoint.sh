#!/bin/bash
set -e

# SSH Host Keys erzeugen
if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
    ssh-keygen -A
fi

exec "$@"
