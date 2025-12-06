#!/usr/bin/env bash
# TFGrid Nextcloud - Update Script

echo "🔄 Nextcloud AIO Update"
echo ""

# Check if mastercontainer is running
if ! docker ps --format '{{.Names}}' | grep -q "^nextcloud-aio-mastercontainer$"; then
    echo "❌ AIO mastercontainer is not running"
    exit 1
fi

echo "Nextcloud AIO handles updates automatically through its interface."
echo ""
echo "📋 To update Nextcloud:"
echo ""
echo "1. Open the AIO interface:"
echo "   https://<server-ip>:8443"
echo ""
echo "2. Check for available updates"
echo ""
echo "3. If updates are available:"
echo "   - Create a backup first (recommended)"
echo "   - Click 'Update' to apply updates"
echo ""
echo "4. Wait for update to complete"
echo ""
echo "📋 To update the AIO mastercontainer itself:"
echo ""
echo "   docker pull ghcr.io/nextcloud-releases/all-in-one:latest"
echo "   docker stop nextcloud-aio-mastercontainer"
echo "   docker rm nextcloud-aio-mastercontainer"
echo "   # Then run configure.sh again"
echo ""
echo "📚 Documentation:"
echo "   https://github.com/nextcloud/all-in-one#how-to-update"
