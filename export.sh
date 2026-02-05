#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
set -a; source "$SCRIPT_DIR/.env"; set +a

echo "--- 正在执行手动导出 ---"
mkdir -p "$LOCAL_BACKUP_DIR"

# 打包
sudo tar -czf "$LOCAL_BACKUP_DIR/$EXPORT_NAME" \
    -C "$WP_ROOT" wp-config.php \
    -C "$WP_ROOT" wp-content/uploads \
    -C "$WP_ROOT" wp-content/plugins \
    -C "$WP_ROOT" wp-content/themes \
    -C "$WP_ROOT" wp-content/database

sudo chown $USER:$USER "$LOCAL_BACKUP_DIR/$EXPORT_NAME"

echo "导出完成：$LOCAL_BACKUP_DIR/$EXPORT_NAME"
