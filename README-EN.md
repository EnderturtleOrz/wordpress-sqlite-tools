# WordPress SQLite Tools

[简体中文](README-ZH.md) | English

This repository provides a set of scripts for backing up, importing, exporting, and automating WordPress sites using SQLite, with support for syncing to Cloudflare R2 via rclone.

**Outputs of scripts all written in Chinese but they should run well**

## 1. Prerequisite
- Linux environment (Ubuntu/Debian recommended)
- bash shell
- Common command-line tools: `tar`, `chown`, `find`, etc.
- rclone installed (for Cloudflare R2 or other object storage)
- WordPress site directory with read/write permissions
- PHP and required extensions:
  ```bash
  sudo apt install php-fpm php-sqlite3 php-curl php-gd php-intl php-mbstring php-xml php-zip
  ```

## 2. Installation & Usage
1. Clone this repository:
   ```bash
   git clone <your_repo_url>
   cd wordpress-sqlite-tools
   ```
2. Make scripts executable:
   ```bash
   chmod +x *.sh
   ```
3. Configure the `.env` file, for example:
   ```env
   WP_ROOT=/var/www/html
   LOCAL_BACKUP_DIR=/root/wp_backups
   # Other custom variables
   ```
4. Run scripts:
   - Export: `./export.sh`
   - Import: `./import.sh <backup_file_path>`
   - Backup (for crontab): `./cron-backup.sh`

## 3. Crontab Automation
Add `cron-backup.sh` to your crontab for automatic backups:

```cron
0 3 * * * /path/to/wordpress-sqlite-tools/cron-backup.sh >> /var/log/wp_backup.log 2>&1
```

## 4. rclone Setup
This tool relies on rclone for remote object storage sync. Please configure rclone first:

1. Install rclone:
   ```bash
   curl https://rclone.org/install.sh | sudo bash
   ```
2. Configure rclone remote:
   ```bash
   rclone config
   ```
   Or edit the config file directly (usually at `~/.config/rclone/rclone.conf`):

   ```ini
   [r2_storage]
   type = s3
   provider = Cloudflare
   access_key_id = abc123
   secret_access_key = xyz456
   endpoint = https://<accountid>.r2.cloudflarestorage.com
   acl = private
   ```

3. Test rclone:
   ```bash
   rclone ls r2_storage:
   ```

---
For issues, please open an issue on GitHub.