# WordPress SQLite Tools

简体中文 | [English](README.md)

本仓库提供了一套用于 WordPress 站点基于 SQLite 数据库的备份、导入、导出和自动化脚本，支持通过 rclone 同步至 Cloudflare R2。

## 1. Prerequisite
- Linux 环境（推荐 Ubuntu/Debian）
- bash shell
- 已安装 `tar`、`chown`、`find` 等常用命令行工具
- 已安装 `rclone`（用于与 Cloudflare R2 等对象存储交互）
- WordPress 站点目录具备读写权限
- PHP 及必要扩展：
   ```bash
   sudo apt install php-fpm php-sqlite3 php-curl php-gd php-intl php-mbstring php-xml php-zip
   ```

## 2. 安装与运行方式
1. 克隆本仓库：
   ```bash
   git clone <your_repo_url>
   cd wordpress-sqlite-tools
   ```
2. 赋予脚本可执行权限：
   ```bash
   chmod +x *.sh
   ```
3. 配置 `.env` 文件，设置如下变量（示例）：
   ```env
   WP_ROOT=/var/www/html
   LOCAL_BACKUP_DIR=/root/wp_backups
   # 其他自定义变量
   ```
4. 运行脚本示例：
   - 导出：`./export.sh`
   - 导入：`./import.sh <备份文件路径>`
   - 备份（crontab 用）：`./cron-backup.sh`

## 3. Crontab 自动备份
建议将 `cron-backup.sh` 脚本加入定时任务，实现自动备份：

```cron
0 3 * * * /path/to/wordpress-sqlite-tools/cron-backup.sh >> /var/log/wp_backup.log 2>&1
```

## 4. rclone 设置
本工具依赖 rclone 进行远程对象存储同步。请先配置 rclone：

1. 安装 rclone：
   ```bash
   curl https://rclone.org/install.sh | sudo bash
   ```
2. 配置 rclone 远程存储：
   ```bash
   rclone config
   ```
   或直接编辑 rclone 配置文件（通常位于 `~/.config/rclone/rclone.conf`， 或者使用 `rclone config file` 查看）：

   ```ini
   [r2_storage]
   type = s3
   provider = Cloudflare
   access_key_id = abc123
   secret_access_key = xyz456
   endpoint = https://<accountid>.r2.cloudflarestorage.com
   acl = private
   ```

3. 测试 rclone 是否配置成功：
   ```bash
   rclone ls r2_storage:
   ```

---
如有问题请提交 issue。