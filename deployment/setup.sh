#!/usr/bin/env bash
# TFGrid Nextcloud - Setup Script
# Installs Docker and prepares for Nextcloud AIO

set -e

echo "🚀 Setting up TFGrid Nextcloud..."

# Update system
echo "📦 Updating system packages..."
apt-get update
apt-get upgrade -y

# Install prerequisites
echo "📦 Installing prerequisites..."
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    jq

# Install Docker
if ! command -v docker &> /dev/null; then
    echo "🐳 Installing Docker..."
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
else
    echo "✅ Docker already installed"
fi

# Create app directories
echo "📁 Creating app directories..."
mkdir -p /opt/nextcloud/{scripts,config}
mkdir -p /var/log/nextcloud

# Copy scripts from deployment source
echo "📋 Copying scripts..."
cp -r /tmp/app-source/scripts/* /opt/nextcloud/scripts/ 2>/dev/null || true
chmod +x /opt/nextcloud/scripts/*.sh 2>/dev/null || true

# Load environment variables
if [ -f /tmp/app-source/.env ]; then
    cp /tmp/app-source/.env /opt/nextcloud/.env
fi

# Set domain from tfgrid-compose variable or .env
cd /opt/nextcloud
if [ -f .env ]; then
    source .env
fi

DOMAIN="${TFGRID_DOMAIN:-${DOMAIN:-localhost}}"

# Update .env with final domain
if [ -f .env ]; then
    grep -q "^DOMAIN=" .env && \
        sed -i "s/^DOMAIN=.*/DOMAIN=$DOMAIN/" .env || \
        echo "DOMAIN=$DOMAIN" >> .env
else
    echo "DOMAIN=$DOMAIN" > .env
fi

echo "✅ Setup complete"
echo "📁 App directory: /opt/nextcloud"
echo "🌐 Domain: $DOMAIN"
