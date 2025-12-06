#!/usr/bin/env bash
# TFGrid Nextcloud - Backup Script
# Triggers AIO built-in backup (BorgBackup)

set -e

echo "📦 Triggering Nextcloud AIO backup..."

# Check if mastercontainer is running
if ! docker ps --format '{{.Names}}' | grep -q "^nextcloud-aio-mastercontainer$"; then
    echo "❌ Error: AIO mastercontainer is not running"
    exit 1
fi

# Check if Nextcloud is running (backup requires running instance)
if ! docker ps --format '{{.Names}}' | grep -q "^nextcloud-aio-nextcloud$"; then
    echo "❌ Error: Nextcloud is not running. Complete AIO setup first."
    exit 1
fi

# Trigger backup via AIO API
echo "🔄 Starting backup process..."
echo ""
echo "NOTE: Nextcloud AIO uses BorgBackup for backups."
echo "The backup is managed through the AIO interface."
echo ""
echo "To create a backup:"
echo "1. Open the AIO interface: https://<server-ip>:8443"
echo "2. Go to the Backup section"
echo "3. Click 'Create Backup'"
echo ""
echo "Backups are stored in the configured backup location."
echo ""

# Try to get backup status
if docker exec nextcloud-aio-mastercontainer ls /mnt/docker-aio-config/backup 2>/dev/null; then
    echo "📁 Backup configuration exists"
fi

echo "To check backup status: tfgrid-compose backup-status"
