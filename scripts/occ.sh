#!/usr/bin/env bash
# TFGrid Nextcloud - OCC Command Script
# Runs Nextcloud occ commands

if [ $# -eq 0 ]; then
    echo "Usage: occ.sh <command>"
    echo ""
    echo "Examples:"
    echo "  occ.sh status"
    echo "  occ.sh user:list"
    echo "  occ.sh maintenance:mode --on"
    echo "  occ.sh files:scan --all"
    echo "  occ.sh config:list"
    exit 1
fi

# Check if Nextcloud container is running
if ! docker ps --format '{{.Names}}' | grep -q "^nextcloud-aio-nextcloud$"; then
    echo "❌ Nextcloud container is not running"
    echo "Complete AIO setup first via https://<server-ip>:8443"
    exit 1
fi

# Run occ command
docker exec -it nextcloud-aio-nextcloud php occ "$@"
