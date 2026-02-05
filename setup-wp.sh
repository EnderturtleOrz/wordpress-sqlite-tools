#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
set -a; source "$SCRIPT_DIR/.env"; set +a

# 1. 配置参数 
PLUGIN_URL="https://github.com/WordPress/sqlite-database-integration/archive/refs/tags/v${SQLITE_VERSION}.tar.gz"

echo "开始全自动安装 WordPress + SQLite (Version: $SQLITE_VERSION)..."

# 2. 准备目录
sudo mkdir -p "$WP_ROOT"
sudo chown $USER:$USER "$WP_ROOT"
cd "$WP_ROOT"

# 3. 下载并解压 WordPress 核心
echo "正在下载最新版 WordPress..."
wget -q https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz --strip-components=1
rm latest.tar.gz

# 4. 配置 SQLite 插件逻辑
echo "正在配置 SQLite 数据库插件..."
mkdir -p wp-content/mu-plugins/sqlite-database-integration
mkdir -p wp-content/database

# 下载并解压插件
curl -L "$PLUGIN_URL" | tar xz --strip-components=1 -C wp-content/mu-plugins/sqlite-database-integration/

# 放置 db.php 引导文件
cp wp-content/mu-plugins/sqlite-database-integration/db.copy wp-content/db.php

# 注入宿主机实际绝对路径到 db.php
sed -i "s|{SQLITE_IMPLEMENTATION_FOLDER_PATH}|$WP_ROOT/wp-content/mu-plugins/sqlite-database-integration|" wp-content/db.php
sed -i 's|{SQLITE_PLUGIN}|sqlite-database-integration/load.php|' wp-content/db.php

# 5. 初始化空白数据库
touch wp-content/database/.ht.sqlite

# 6. 预设 wp-config.php
# SQLite 模式下数据库名和用户不重要，但必须存在定义
if [ ! -f wp-config.php ]; then
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/blog_db/" wp-config.php
    sed -i "s/username_here/admin/" wp-config.php
    sed -i "s/password_here/pass/" wp-config.php
fi

# 7. 权限设置
echo "正在设置 www-data 权限..."
sudo chown -R www-data:www-data "$WP_ROOT"
sudo find "$WP_ROOT" -type d -exec chmod 755 {} \;
sudo find "$WP_ROOT" -type f -exec chmod 644 {} \;

echo "------------------------------------------------"
echo "恭喜！WordPress + SQLite 部署完成。"
echo "安装路径: $WP_ROOT"
echo "现在请访问你的域名进行最后的一键安装。"
echo "------------------------------------------------"
