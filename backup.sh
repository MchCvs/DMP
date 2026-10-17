#!/bin/bash
DMP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$DMP_ROOT/backups/dmp_$DATE.tar.gz"
mkdir -p $DMP_ROOT/backups
tar -czf "$BACKUP_FILE" $DMP_ROOT --exclude=backups --exclude=logs
echo "✅ Backup: $BACKUP_FILE"
