#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="/home/thierry/DMP-FINAL/backups/dmp_$DATE.tar.gz"
mkdir -p /home/thierry/DMP-FINAL/backups
tar -czf "$BACKUP_FILE" /home/thierry/DMP-FINAL --exclude=backups --exclude=logs
echo "✅ Backup: $BACKUP_FILE"
