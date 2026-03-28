#!/bin/bash
# diy-part2.sh

set -e

echo "===================="
echo "DIY Part2 Script Start"
echo "===================="

cd "$GITHUB_WORKSPACE/openwrt"

# -----------------------
# 1️⃣ 获取最新 Pre-release Alpha 内核 URL
# -----------------------
echo "Fetching latest Mihomo Clash Meta Alpha release URL..."
ALPHA_URL=$(curl -s https://api.github.com/repos/Mihoho/OpenClash_Core/releases \
    | grep -E '"tag_name":|"browser_download_url":' \
    | grep -B1 'clash_meta_amd64.gz' \
    | grep '"browser_download_url":' \
    | head -n1 \
    | cut -d '"' -f4)

if [ -z "$ALPHA_URL" ]; then
    echo "⚠ Could not fetch Alpha URL, fallback to last known URL"
    ALPHA_URL="https://github.com/Mihoho/OpenClash_Core/releases/download/Alpha-2026.03.01/clash_meta_amd64.gz"
fi

echo "Latest Alpha URL: $ALPHA_URL"

# -----------------------
# 2️⃣ 下载内核到 files/usr/bin
# -----------------------
mkdir -p files/usr/bin
curl -L "$ALPHA_URL" | gunzip -c > files/usr/bin/clash_meta
chmod +x files/usr/bin/clash_meta
echo "✓ Latest Mihomo Clash Meta Alpha core downloaded to files/usr/bin/clash_meta"

# Modify default IP
sed -i 's/192.168.1.1/192.168.25.1/g' package/base-files/files/bin/config_generate
