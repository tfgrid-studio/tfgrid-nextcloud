# TFGrid Nextcloud

Nextcloud All-in-One cloud platform on ThreeFold Grid.

## Overview

Deploy a complete Nextcloud instance with:
- **Nextcloud AIO** - All-in-One deployment with automatic management
- **Built-in SSL** - Let's Encrypt certificates handled by AIO
- **BorgBackup** - Automatic encrypted backups
- **Auto-updates** - Managed through AIO interface
- **Automatic DNS** - Optional DNS A record creation (Name.com, Namecheap, Cloudflare)

## Features

- 📁 **File Sync & Share** - Access files from anywhere
- 📅 **Calendar & Contacts** - Integrated productivity apps
- 📧 **Email Integration** - Connect your email accounts
- 🎥 **Talk** - Video calls and chat (optional)
- 📝 **Office** - Collaborative document editing (Collabora/OnlyOffice)
- 🔒 **End-to-end Encryption** - Optional E2EE for sensitive files

## Quick Start

### Basic Deployment (Interactive)

The easiest way to deploy - answers questions interactively:

```bash
tfgrid-compose up tfgrid-nextcloud -i
```

This will prompt you for:
1. Domain name
2. DNS provider (optional automatic setup)
3. Nextcloud settings
4. Optional features (Talk, Collabora, OnlyOffice)
5. Resource allocation
6. Node selection

### One-Line Deployment

Deploy with all settings on the command line:

```bash
tfgrid-compose up tfgrid-nextcloud \
  --env DOMAIN=cloud.example.com \
  --env NEXTCLOUD_ADMIN_USER=admin \
  --env NEXTCLOUD_UPLOAD_LIMIT=10G
```

### Full Deployment Example

Complete deployment with DNS automation and all options:

```bash
# With Cloudflare DNS and optional features
tfgrid-compose up tfgrid-nextcloud \
  --env DOMAIN=cloud.example.com \
  --env DNS_PROVIDER=cloudflare \
  --env CLOUDFLARE_API_TOKEN=your-cf-token \
  --env NEXTCLOUD_ADMIN_USER=myadmin \
  --env NEXTCLOUD_UPLOAD_LIMIT=20G \
  --env NEXTCLOUD_MEMORY_LIMIT=1G \
  --env COLLABORA_ENABLED=true \
  --env TALK_ENABLED=true \
  --cpu 4 \
  --memory 8192 \
  --disk 500

# With Name.com DNS
tfgrid-compose up tfgrid-nextcloud \
  --env DOMAIN=cloud.example.com \
  --env DNS_PROVIDER=name.com \
  --env NAMECOM_USERNAME=myuser \
  --env NAMECOM_API_TOKEN=your-token
```

## Configuration

### Environment Variables

#### Domain & DNS

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `DOMAIN` | **Yes** | - | Public domain for Nextcloud |
| `DNS_PROVIDER` | No | `manual` | DNS provider: `manual`, `name.com`, `namecheap`, `cloudflare` |
| `NAMECOM_USERNAME` | If name.com | - | Name.com username |
| `NAMECOM_API_TOKEN` | If name.com | - | Name.com API token |
| `NAMECHEAP_API_USER` | If namecheap | - | Namecheap API username |
| `NAMECHEAP_API_KEY` | If namecheap | - | Namecheap API key |
| `CLOUDFLARE_API_TOKEN` | If cloudflare | - | Cloudflare API token |

#### Nextcloud Settings

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `NEXTCLOUD_ADMIN_USER` | No | `admin` | Admin username |
| `NEXTCLOUD_ADMIN_PASSWORD` | No | auto-generated | Admin password |
| `NEXTCLOUD_DATADIR` | No | `/mnt/ncdata` | Data directory path |
| `NEXTCLOUD_UPLOAD_LIMIT` | No | `10G` | Maximum upload file size |
| `NEXTCLOUD_MEMORY_LIMIT` | No | `512M` | PHP memory limit |

#### Optional Features

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `COLLABORA_ENABLED` | No | `false` | Enable Collabora Online Office |
| `TALK_ENABLED` | No | `false` | Enable Nextcloud Talk video calls |
| `ONLYOFFICE_ENABLED` | No | `false` | Enable OnlyOffice (alternative to Collabora) |

#### Backup

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `BACKUP_LOCATION` | No | `/mnt/backup` | Backup storage location |
| `BACKUP_RETENTION` | No | `7` | Number of backups to keep |

## Setup Process

1. **Deploy** - Run `tfgrid-compose up tfgrid-nextcloud -i`
2. **Access AIO** - Open `https://<server-ip>:8443`
3. **Configure** - Enter your domain and set admin password
4. **Start** - Click "Start containers" in AIO interface
5. **Access** - Open `https://your-domain.com`

## Commands

| Command | Description |
|---------|-------------|
| `tfgrid-compose backup` | Trigger AIO backup |
| `tfgrid-compose backup-status` | Check backup status |
| `tfgrid-compose restore` | Show restore instructions |
| `tfgrid-compose logs [service]` | View logs |
| `tfgrid-compose occ <cmd>` | Run Nextcloud occ commands |
| `tfgrid-compose update` | Check for updates |
| `tfgrid-compose restart` | Restart services |

## Resource Requirements

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| CPU | 2 cores | 4 cores |
| Memory | 4 GB | 8 GB |
| Disk | 50 GB | 200 GB |

## Architecture

```
┌─────────────┐     ┌───────────────────────────────────┐
│   Internet  │────▶│  Nextcloud AIO                    │
│             │     │  (Apache + Let's Encrypt)         │
└─────────────┘     └───────────────┬───────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
              ┌─────▼─────┐   ┌─────▼─────┐   ┌─────▼─────┐
              │ Nextcloud │   │ PostgreSQL│   │   Redis   │
              │   App     │   │  Database │   │   Cache   │
              └───────────┘   └───────────┘   └───────────┘
```

## Backup & Restore

### Backups
Nextcloud AIO uses BorgBackup with:
- Automatic daily backups
- Deduplication (saves space)
- Encryption
- Remote backup support

Configure backups via the AIO interface.

### Restore
Restore is done through the AIO interface:
1. Open `https://<server-ip>:8443`
2. Go to Backup section
3. Select backup to restore
4. Click Restore

## Ports

| Port | Service |
|------|---------|
| 80 | HTTP (redirects to HTTPS) |
| 443 | HTTPS (Nextcloud) |
| 8080 | AIO Interface (HTTP) |
| 8443 | AIO Interface (HTTPS) |

## Troubleshooting

### Check Service Status
```bash
tfgrid-compose healthcheck
```

### View Logs
```bash
tfgrid-compose logs                    # All logs
tfgrid-compose logs mastercontainer    # AIO logs
tfgrid-compose logs nextcloud          # Nextcloud logs
```

### Common Issues

**AIO interface not accessible**
- Ensure port 8443 is open
- Check Docker is running: `systemctl status docker`

**SSL certificate not working**
- Ensure domain DNS points to server IP
- Check AIO logs for Let's Encrypt errors

**Slow performance**
- Increase memory: set `NEXTCLOUD_MEMORY_LIMIT=1024M`
- Check disk I/O and available space

## License

Apache 2.0