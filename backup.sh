#!/bin/bash
DMP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$DMP_ROOT/backups/dmp_$DATE.tar.gz"
mkdir -p "$DMP_ROOT/backups"
if tar -czf "$BACKUP_FILE" -C "$DMP_ROOT" --exclude=./backups --exclude=./logs . ; then
    echo "✅ Backup: $BACKUP_FILE"
else
    echo "❌ Échec de la sauvegarde" >&2
    rm -f "$BACKUP_FILE"
    exit 1
fi
