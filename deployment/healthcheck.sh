#!/usr/bin/env bash
# TFGrid Nextcloud - Health Check Script

set -e

ERRORS=0

echo "🔍 Running Nextcloud health checks..."

# Check Docker is running
if ! systemctl is-active --quiet docker; then
    echo "❌ Docker is not running"
    ERRORS=$((ERRORS + 1))
else
    echo "✅ Docker is running"
fi

# Check mastercontainer
if docker ps --format '{{.Names}}' | grep -q "^nextcloud-aio-mastercontainer$"; then
    echo "✅ AIO mastercontainer is running"
else
    echo "❌ AIO mastercontainer is not running"
    ERRORS=$((ERRORS + 1))
fi

# Check for Nextcloud container (started after AIO setup)
if docker ps --format '{{.Names}}' | grep -q "^nextcloud-aio-nextcloud$"; then
    echo "✅ Nextcloud container is running"
    
    # Check Nextcloud HTTP response
    HTTP_CODE=$(docker exec nextcloud-aio-nextcloud curl -s -o /dev/null -w "%{http_code}" http://localhost/status.php 2>/dev/null || echo "000")
    if [ "$HTTP_CODE" = "200" ]; then
        echo "✅ Nextcloud HTTP check passed"
    else
        echo "⚠️ Nextcloud HTTP check: status $HTTP_CODE"
    fi
else
    echo "⚠️ Nextcloud container not running (complete AIO setup first)"
fi

# Check database container
if docker ps --format '{{.Names}}' | grep -q "^nextcloud-aio-database$"; then
    echo "✅ Database container is running"
else
    echo "⚠️ Database container not running (complete AIO setup first)"
fi

# Check redis container
if docker ps --format '{{.Names}}' | grep -q "^nextcloud-aio-redis$"; then
    echo "✅ Redis container is running"
else
    echo "⚠️ Redis container not running (complete AIO setup first)"
fi

# Check AIO interface
AIO_CODE=$(curl -sk -o /dev/null -w "%{http_code}" https://localhost:8443 2>/dev/null || echo "000")
if [ "$AIO_CODE" = "200" ] || [ "$AIO_CODE" = "302" ]; then
    echo "✅ AIO interface is accessible"
else
    echo "⚠️ AIO interface status: $AIO_CODE"
fi

# Check disk space
DISK_USAGE=$(df /var/lib/docker 2>/dev/null | tail -1 | awk '{print $5}' | tr -d '%')
if [ -n "$DISK_USAGE" ] && [ "$DISK_USAGE" -lt 90 ]; then
    echo "✅ Disk usage: ${DISK_USAGE}%"
else
    echo "⚠️ Disk usage is high: ${DISK_USAGE}%"
fi

# Summary
echo ""
if [ $ERRORS -eq 0 ]; then
    echo "✅ All critical health checks passed"
    exit 0
else
    echo "❌ $ERRORS critical health check(s) failed"
    exit 1
fi
