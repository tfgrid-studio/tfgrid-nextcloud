#!/usr/bin/env bash
# TFGrid Nextcloud - Logs Script

SERVICE="${1:-all}"
FOLLOW=""

# Check for --follow flag
for arg in "$@"; do
    if [ "$arg" = "--follow" ] || [ "$arg" = "-f" ]; then
        FOLLOW="-f"
    fi
done

case "$SERVICE" in
    master|mastercontainer|aio)
        echo "📋 AIO Mastercontainer logs:"
        docker logs $FOLLOW nextcloud-aio-mastercontainer
        ;;
    nextcloud|nc)
        echo "📋 Nextcloud logs:"
        if docker ps --format '{{.Names}}' | grep -q "^nextcloud-aio-nextcloud$"; then
            docker logs $FOLLOW nextcloud-aio-nextcloud
        else
            echo "Nextcloud container not running. Complete AIO setup first."
        fi
        ;;
    database|db|postgres)
        echo "📋 Database logs:"
        if docker ps --format '{{.Names}}' | grep -q "^nextcloud-aio-database$"; then
            docker logs $FOLLOW nextcloud-aio-database
        else
            echo "Database container not running. Complete AIO setup first."
        fi
        ;;
    redis|cache)
        echo "📋 Redis logs:"
        if docker ps --format '{{.Names}}' | grep -q "^nextcloud-aio-redis$"; then
            docker logs $FOLLOW nextcloud-aio-redis
        else
            echo "Redis container not running. Complete AIO setup first."
        fi
        ;;
    apache|web)
        echo "📋 Apache logs:"
        if docker ps --format '{{.Names}}' | grep -q "^nextcloud-aio-apache$"; then
            docker logs $FOLLOW nextcloud-aio-apache
        else
            echo "Apache container not running. Complete AIO setup first."
        fi
        ;;
    all|"")
        echo "📋 All Nextcloud AIO logs (last 50 lines each):"
        echo ""
        echo "=== Mastercontainer ==="
        docker logs --tail 50 nextcloud-aio-mastercontainer 2>&1
        
        if docker ps --format '{{.Names}}' | grep -q "^nextcloud-aio-nextcloud$"; then
            echo ""
            echo "=== Nextcloud ==="
            docker logs --tail 50 nextcloud-aio-nextcloud 2>&1
        fi
        
        if docker ps --format '{{.Names}}' | grep -q "^nextcloud-aio-apache$"; then
            echo ""
            echo "=== Apache ==="
            docker logs --tail 50 nextcloud-aio-apache 2>&1
        fi
        ;;
    *)
        echo "Unknown service: $SERVICE"
        echo "Usage: logs.sh [mastercontainer|nextcloud|database|redis|apache|all] [--follow]"
        exit 1
        ;;
esac
