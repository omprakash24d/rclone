#!/bin/bash
# Sync OneDrive photos/videos to Google Photos folder
/usr/bin/rclone sync onedrive2:Pictures gdrive:GooglePhotos --include "*.jpg" --include "*.png" --include "*.mp4" --include "*.mov" --fast-list -P
