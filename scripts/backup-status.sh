#!/usr/bin/env bash
# TFGrid Nextcloud - Backup Status Script

echo "📦 Nextcloud AIO Backup Status"
echo ""

# Check if mastercontainer is running
if ! docker ps --format '{{.Names}}' | grep -q "^nextcloud-aio-mastercontainer$"; then
    echo "❌ AIO mastercontainer is not running"
    exit 1
fi

# Check backup configuration
echo "Checking backup configuration..."
echo ""

# Try to read backup info from AIO config
if docker exec nextcloud-aio-mastercontainer cat /mnt/docker-aio-config/data/configuration.json 2>/dev/null | jq -r '.backup_location // "Not configured"' 2>/dev/null; then
    echo ""
else
    echo "Backup location: Check AIO interface"
fi

echo ""
echo "📋 To view detailed backup status:"
echo "   1. Open AIO interface: https://<server-ip>:8443"
echo "   2. Navigate to Backup section"
echo ""
echo "📋 Backup features (via AIO):"
echo "   - Automatic daily backups"
echo "   - BorgBackup with deduplication"
echo "   - Encrypted backups"
echo "   - Remote backup support"
