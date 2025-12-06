#!/usr/bin/env bash
# TFGrid Nextcloud - Configure Script
# Starts Nextcloud AIO mastercontainer

set -e

echo "⚙️ Configuring TFGrid Nextcloud..."

cd /opt/nextcloud

# Load environment
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

# Get domain (from tfgrid-compose or .env)
DOMAIN="${TFGRID_DOMAIN:-${DOMAIN:-localhost}}"
NEXTCLOUD_DATADIR="${NEXTCLOUD_DATADIR:-}"
NEXTCLOUD_UPLOAD_LIMIT="${NEXTCLOUD_UPLOAD_LIMIT:-10G}"
NEXTCLOUD_MEMORY_LIMIT="${NEXTCLOUD_MEMORY_LIMIT:-512M}"
NEXTCLOUD_TIMEZONE="${NEXTCLOUD_TIMEZONE:-UTC}"

echo "🌐 Configuring for domain: $DOMAIN"

# Stop existing container if running
docker stop nextcloud-aio-mastercontainer 2>/dev/null || true
docker rm nextcloud-aio-mastercontainer 2>/dev/null || true

# Build docker run command
DOCKER_CMD="docker run -d"
DOCKER_CMD="$DOCKER_CMD --name nextcloud-aio-mastercontainer"
DOCKER_CMD="$DOCKER_CMD --restart always"
DOCKER_CMD="$DOCKER_CMD -p 80:80"
DOCKER_CMD="$DOCKER_CMD -p 8080:8080"
DOCKER_CMD="$DOCKER_CMD -p 8443:8443"
DOCKER_CMD="$DOCKER_CMD -e NEXTCLOUD_DATADIR=${NEXTCLOUD_DATADIR:-/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data}"
DOCKER_CMD="$DOCKER_CMD -e NEXTCLOUD_UPLOAD_LIMIT=$NEXTCLOUD_UPLOAD_LIMIT"
DOCKER_CMD="$DOCKER_CMD -e NEXTCLOUD_MEMORY_LIMIT=$NEXTCLOUD_MEMORY_LIMIT"
DOCKER_CMD="$DOCKER_CMD -e TZ=$NEXTCLOUD_TIMEZONE"
DOCKER_CMD="$DOCKER_CMD -v nextcloud_aio_mastercontainer:/mnt/docker-aio-config"
DOCKER_CMD="$DOCKER_CMD -v /var/run/docker.sock:/var/run/docker.sock:ro"
DOCKER_CMD="$DOCKER_CMD ghcr.io/nextcloud-releases/all-in-one:latest"

# Start Nextcloud AIO mastercontainer
echo "🐳 Starting Nextcloud AIO mastercontainer..."
eval $DOCKER_CMD

# Wait for container to start
echo "⏳ Waiting for AIO interface to be ready..."
sleep 10

# Check if AIO interface is responding
MAX_ATTEMPTS=30
ATTEMPT=0
while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    if curl -sk -o /dev/null -w "%{http_code}" https://localhost:8443 | grep -q "200\|302\|301"; then
        echo "✅ AIO interface is responding"
        break
    fi
    ATTEMPT=$((ATTEMPT + 1))
    echo "⏳ Waiting for AIO interface... ($ATTEMPT/$MAX_ATTEMPTS)"
    sleep 5
done

# Save configuration info
cat > /opt/nextcloud/config/info.json <<EOF
{
    "domain": "$DOMAIN",
    "configured_at": "$(date -Iseconds)",
    "aio_interface": "https://<server-ip>:8443",
    "nextcloud_url": "https://$DOMAIN"
}
EOF

echo ""
echo "✅ Nextcloud AIO started!"
echo ""
echo "📝 IMPORTANT: Complete setup via the AIO interface"
echo ""
echo "1. Open the AIO interface:"
echo "   https://<your-server-ip>:8443"
echo ""
echo "2. Enter your domain: $DOMAIN"
echo ""
echo "3. Follow the setup wizard to:"
echo "   - Set admin password"
echo "   - Configure optional features"
echo "   - Start Nextcloud containers"
echo ""
echo "4. Once complete, access Nextcloud at:"
echo "   https://$DOMAIN"
echo ""
echo "🔧 Management Commands:"
echo "   Logs: tfgrid-compose logs"
echo "   Backup: tfgrid-compose backup"
echo "   Update: tfgrid-compose update"
