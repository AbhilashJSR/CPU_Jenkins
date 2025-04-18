#!/bin/bash

# === Config ===
REPORT_DIR="/path/to/report_dir"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="$REPORT_DIR/system_report_$TIMESTAMP.txt"
GIT_REPO_DIR="/path/to/git_repo"
S3_BUCKET_NAME="your-s3-bucket-name"
AWS_PROFILE="default"  # or leave empty if not using profiles

# === Create report directory if not exists ===
mkdir -p "$REPORT_DIR"

# === Collect CPU and memory usage ===
{
    echo "===== System Report: $TIMESTAMP ====="
    echo
    echo "--- CPU Usage ---"
    top -b -n1 | grep "Cpu(s)"
    echo
    echo "--- Memory Usage ---"
    free -h
    echo
    echo "--- Disk Usage ---"
    df -h
} > "$REPORT_FILE"

# === Copy report to Git repo directory ===
cp "$REPORT_FILE" "$GIT_REPO_DIR"

cd "$GIT_REPO_DIR" || exit 1

# === Git operations ===
git pull origin main
git add "$(basename "$REPORT_FILE")"
git commit -m "System report added for $TIMESTAMP"
git push origin main

# === Upload to S3 ===
if [[ -z "$AWS_PROFILE" ]]; then
    aws s3 cp "$REPORT_FILE" "s3://$S3_BUCKET_NAME/"
else
    aws s3 cp "$REPORT_FILE" "s3://$S3_BUCKET_NAME/" --profile "$AWS_PROFILE"
fi
