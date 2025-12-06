#!/usr/bin/env bash
# TFGrid Nextcloud - Restart Script

echo "🔄 Restarting Nextcloud AIO..."

# Restart mastercontainer
echo "Restarting AIO mastercontainer..."
docker restart nextcloud-aio-mastercontainer

# Wait for it to be ready
sleep 5

# Restart other containers if running
for container in nextcloud-aio-nextcloud nextcloud-aio-apache nextcloud-aio-database nextcloud-aio-redis; do
    if docker ps -a --format '{{.Names}}' | grep -q "^${container}$"; then
        echo "Restarting $container..."
        docker restart $container 2>/dev/null || true
    fi
done

echo ""
echo "✅ Restart complete"
echo ""
echo "Check status with: tfgrid-compose healthcheck"
