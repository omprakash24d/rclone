# 1. Create the shell script

In your home directory (or a folder of your choice), create a file named `rclone-photos-sync.sh`:

```bash
#!/bin/bash
# Script to sync photos and videos from OneDrive to Google Photos folder on Google Drive

/usr/bin/rclone sync onedrive2:Pictures gdrive:GooglePhotos \
  --include "*.jpg" --include "*.jpeg" --include "*.png" --include "*.gif" \
  --include "*.mp4" --include "*.mov" --fast-list -P
```

Save and exit.

Make it executable:

```bash
chmod +x ~/rclone-photos-sync.sh
```

---

# 2. Create the systemd service file

Create the systemd service file in your user systemd folder (create the folder if it doesn’t exist):

```bash
mkdir -p ~/.config/systemd/user
gedit ~/.config/systemd/user/rclone-photos-sync.service
```

Paste the following:

```ini
[Unit]
Description=Rclone sync OneDrive photos/videos to Google Photos folder on Google Drive on startup
After=network-online.target

[Service]
Type=oneshot
ExecStart=/home/yourusername/rclone-photos-sync.sh
Restart=no

[Install]
WantedBy=default.target
```

Make sure to replace `/home/yourusername` with your actual home directory path.

Save and exit.

---

# 3. Enable and start the service

Reload systemd user units:

```bash
systemctl --user daemon-reload
```

Enable the service to run on startup:

```bash
systemctl --user enable rclone-photos-sync.service
```

Start the service now (to test it):

```bash
systemctl --user start rclone-photos-sync.service
```

---

# 4. Verify the sync

You can check the status or logs by running:

```bash
systemctl --user status rclone-photos-sync.service
journalctl --user -u rclone-photos-sync.service
```

---

# 5. Add this to your GitHub repo

Create a folder like `rclone-setup` and add:

* `rclone-photos-sync.sh`
* `rclone-photos-sync.service`
* `README.md` (see below for example)

---

# 6. Example README.md snippet

````markdown
# Rclone OneDrive to Google Photos Auto-Sync Setup

## Overview
This setup syncs all photos and videos from your OneDrive `Pictures` folder to your Google Drive `GooglePhotos` folder on system startup.

## Files

- `rclone-photos-sync.sh`: Script to run the rclone sync command.
- `rclone-photos-sync.service`: systemd user service to automate sync on boot.

## Setup Instructions

1. Place `rclone-photos-sync.sh` in your home directory and make it executable:

   ```bash
   chmod +x ~/rclone-photos-sync.sh
````

2. Copy `rclone-photos-sync.service` to `~/.config/systemd/user/`.

3. Replace `/home/yourusername/` in the `.service` file with your actual home directory.

4. Reload systemd user services:

   ```bash
   systemctl --user daemon-reload
   ```

5. Enable the service:

   ```bash
   systemctl --user enable rclone-photos-sync.service
   ```

6. Start the service:

   ```bash
   systemctl --user start rclone-photos-sync.service
   ```

7. Check status and logs:

   ```bash
   systemctl --user status rclone-photos-sync.service
   journalctl --user -u rclone-photos-sync.service
   ```

## Notes

* Sync includes `.jpg`, `.jpeg`, `.png`, `.gif`, `.mp4`, `.mov` file types.
* Google Photos automatically detects duplicates, so no need to worry about repeated uploads.
* Adjust folder names if your OneDrive or Google Drive folders differ.

```
