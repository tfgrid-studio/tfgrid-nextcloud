# TFGrid Nextcloud

Nextcloud All-in-One cloud platform on ThreeFold Grid.

## Overview

Deploy a complete Nextcloud instance with:
- **Nextcloud AIO** - All-in-One deployment with automatic management
- **Built-in SSL** - Let's Encrypt certificates handled by AIO
- **BorgBackup** - Automatic encrypted backups
- **Auto-updates** - Managed through AIO interface

## Features

- 📁 **File Sync & Share** - Access files from anywhere
- 📅 **Calendar & Contacts** - Integrated productivity apps
- 📧 **Email Integration** - Connect your email accounts
- 🎥 **Talk** - Video calls and chat
- 📝 **Office** - Collaborative document editing
- 🔒 **End-to-end Encryption** - Optional E2EE for sensitive files

## Quick Start

```bash
# Deploy with tfgrid-compose
tfgrid-compose up tfgrid-nextcloud

# Or manually:
cp .env.example .env
nano .env  # Set your domain

tfgrid-compose up .
```

After deployment, complete setup via the AIO interface at `https://<server-ip>:8443`.

## Configuration

### Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `DOMAIN` | Yes | Public domain for Nextcloud |
| `NEXTCLOUD_DATADIR` | No | Custom data directory |
| `NEXTCLOUD_UPLOAD_LIMIT` | No | Max upload size (default: 10G) |
| `NEXTCLOUD_MEMORY_LIMIT` | No | PHP memory limit (default: 512M) |

### Example .env

```bash
DOMAIN=cloud.example.com
NEXTCLOUD_UPLOAD_LIMIT=10G
```

## Setup Process

1. **Deploy** - Run `tfgrid-compose up tfgrid-nextcloud`
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