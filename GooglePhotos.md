# 🗂️ Rclone OneDrive to Google Drive Auto Sync on Boot — Setup Documentation

## 🔧 Objective:

Sync files and folders from **OneDrive (onedrive2)** to a specific folder (`OneDriveSync1`) in **Google Drive**, **automatically on system boot** using `rclone` and `systemd`.

---

## 📦 Prerequisites

Ensure the following tools are installed:

```bash
sudo apt update
sudo apt install rclone
```

You must also have:

* A working internet connection
* Access to both OneDrive and Google Drive accounts
* A GUI browser (for authentication)
* Some terminal familiarity

---

## 1️⃣ Configure Rclone Remotes

### 🟦 OneDrive (onedrive2)

```bash
rclone config
```

* Choose `n` (new remote)
* Name it: `onedrive2`
* Choose type: `OneDrive`
* Authenticate using your browser
* Choose: OneDrive for Business
* Finish configuration

### 🟩 Google Drive (gdrive)

```bash
rclone config
```

* Choose `n` (new remote)
* Name it: `gdrive`
* Choose type: `Google Drive`
* Authenticate in browser
* Finish setup

✅ Verify:

```bash
rclone listremotes
# Should show:
# onedrive2:
# gdrive:
```

---

## 2️⃣ Test the Sync Command

Use this command to manually test the sync:

```bash
rclone sync onedrive2: gdrive:OneDriveSync1 -P
```

* `onedrive2:` – source remote
* `gdrive:OneDriveSync1` – destination folder in Google Drive
* `-P` – show progress

✅ Confirm that files and folders are being copied properly.

---

## 3️⃣ Create Auto-Sync Script

Create a sync script:

```bash
sudo nano /usr/local/bin/rclone-onedrive-sync.sh
```

Paste:

```bash
#!/bin/bash
rclone sync onedrive2: gdrive:OneDriveSync1 -v --log-file=/home/YOUR_USERNAME/rclone-sync.log
```

> Replace `YOUR_USERNAME` with your actual username.

Save and exit.

Make it executable:

```bash
sudo chmod +x /usr/local/bin/rclone-onedrive-sync.sh
```

---

## 4️⃣ Create systemd User Service

Instead of running as a root system service, you’ve set it up as a **user-level service**.

Create the service file:

```bash
mkdir -p ~/.config/systemd/user
nano ~/.config/systemd/user/rclone-sync.service
```

Paste:

```ini
[Unit]
Description=Rclone Sync OneDrive2 to Google Drive on Startup
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/rclone-onedrive-sync.sh
RemainAfterExit=true

[Install]
WantedBy=default.target
```

Save and exit.

---

## 5️⃣ Enable and Start the Service

```bash
systemctl --user daemon-reload
systemctl --user enable rclone-sync.service
systemctl --user start rclone-sync.service
```

> ✅ The service will now run automatically **every time you log in** (after boot).

---

## 6️⃣ Monitor the Sync

You can view the log at any time:

```bash
tail -f ~/rclone-sync.log
```

Or check service status:

```bash
systemctl --user status rclone-sync.service
```

---

## ✅ Summary of What Was Set Up

| Component       | Details                                  |
| --------------- | ---------------------------------------- |
| Source          | OneDrive2 (`onedrive2`)                  |
| Destination     | Google Drive → `OneDriveSync1` folder    |
| Sync type       | One-time sync (on each boot/login)       |
| Sync method     | `rclone sync`                            |
| Automation      | systemd user service                     |
| Log location    | `~/rclone-sync.log`                      |
| Script location | `/usr/local/bin/rclone-onedrive-sync.sh` |
| Service name    | `rclone-sync.service`                    |

---

## 🔁 To Manually Trigger Sync Anytime

```bash
systemctl --user start rclone-sync.service
```

Or run the script directly:

```bash
bash /usr/local/bin/rclone-onedrive-sync.sh
```

---

## ⚠️ Notes

* This sync is **one-way**: from OneDrive → Google Drive.
* It's not real-time. It syncs **once on boot/login**.
* Duplicate syncs won’t re-upload files — `rclone` skips unchanged files.
* Always make sure both remotes are still authorized (tokens expire after months if unused).

---

## 🧼 Cleanup or Disable

To disable auto-sync:

```bash
systemctl --user disable rclone-sync.service
```

To remove:

```bash
rm ~/.config/systemd/user/rclone-sync.service
rm /usr/local/bin/rclone-onedrive-sync.sh
```

---
