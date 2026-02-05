#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
set -a; source "$SCRIPT_DIR/.env"; set +a

DATE=$(date +%Y%m%d_%H%M%S)
FILE_NAME="wp_backup_$DATE.tar.gz"
FULL_PATH="$LOCAL_BACKUP_DIR/$FILE_NAME"

echo "[$DATE] 开始自动备份流程..."

# 1. 打包
mkdir -p "$LOCAL_BACKUP_DIR"
sudo tar -czf "$FULL_PATH" \
    -C "$WP_ROOT" wp-config.php \
    -C "$WP_ROOT" wp-content/uploads \
    -C "$WP_ROOT" wp-content/plugins \
    -C "$WP_ROOT" wp-content/themes \
    -C "$WP_ROOT" wp-content/database
sudo chown $USER:$USER "$FULL_PATH"

# 2. 同步 R2
rclone copy "$FULL_PATH" "$RCLONE_REMOTE:$REMOTE_DIR"

# 3. 清理本地与云端
find "$LOCAL_BACKUP_DIR" -name "wp_backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete
rclone delete "$RCLONE_REMOTE:$REMOTE_DIR" --min-age ${RETENTION_DAYS}d --rmdirs

echo "[$DATE] 任务结束。"
