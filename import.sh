#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
set -a; source "$SCRIPT_DIR/.env"; set +a

# 1. 检查是否提供了参数
TARGET_FILE="$1"
if [ -z "$TARGET_FILE" ]; then
    echo "错误：未指定备份文件！"
    echo "用法: $0 <文件名或路径>"
    echo "例如: $0 wp_backup_20260204.tar.gz"
    exit 1
fi

# 2. 直接使用用户输入的路径
FULL_PATH="$TARGET_FILE"

echo "--- 正在启动导入流程 ---"
echo "目标文件: $FULL_PATH"

# 3. 严格检查文件是否存在
if [ ! -f "$FULL_PATH" ]; then
    echo "错误：找不到备份文件！"
    echo "路径确认: $FULL_PATH"
    exit 1
fi

# 4. 确认操作
read -p "这将覆盖 $WP_ROOT 中的现有数据，确定吗？(y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "操作已取消。"
    exit 1
fi

# 5. 覆盖数据
echo "正在解压并覆盖用户资产..."
sudo tar -xzf "$FULL_PATH" -C "$WP_ROOT"

# 6. 重新校准权限
echo "正在修复权限 (www-data)..."
sudo chown -R www-data:www-data "$WP_ROOT"
sudo find "$WP_ROOT" -type d -exec chmod 755 {} \;
sudo find "$WP_ROOT" -type f -exec chmod 644 {} \;

echo "------------------------------------------------"
echo "导入成功！"
echo "数据已成功同步至: $WP_ROOT"
echo "------------------------------------------------"
