#!/bin/bash
# diy-part2.sh
# OpenClash + Mihomo x86_64 Clash Meta Alpha
# 编译阶段下载最新 Alpha 内核 + 默认配置 + 开机自动启动

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

# -----------------------
# 3️⃣ 创建默认 OpenClash 配置
# -----------------------
mkdir -p files/etc/openclash

cat > files/etc/openclash/config.yaml << 'EOF'
port: 7890
socks-port: 7891
allow-lan: true
mode: Rule
log-level: info
external-controller: 0.0.0.0:9090
proxies:
  - {name: "auto", type: direct}
proxy-groups:
  - name: "Auto"
    type: select
    proxies:
      - auto
rules:
  - MATCH,Auto
EOF

echo "✓ Default OpenClash configuration created"

# -----------------------
# 4️⃣ 安装 LuCI OpenClash 插件
# -----------------------
grep -q "openclash" feeds.conf.default || \
    echo "src-git openclash https://github.com/vernesong/OpenClash.git" >> feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -a luci-app-openclash
echo "✓ OpenClash feed and LuCI plugin installed"

# -----------------------
# 5️⃣ 开机自动启动
# -----------------------
cat > files/etc/init.d/openclash << 'EOF'
#!/bin/sh /etc/rc.common
START=99
STOP=10

CLASH_BIN="/usr/bin/clash_meta"
CLASH_DIR="/etc/openclash"
TMP_BIN="/tmp/clash_meta_new"

start() {
    echo "Starting OpenClash..."
    # 启动 Clash
    $CLASH_BIN -d $CLASH_DIR >/tmp/clash.log 2>&1 &
}

stop() {
    echo "Stopping OpenClash..."
    pkill clash_meta || true
}
EOF

chmod +x files/etc/init.d/openclash
ln -sf /etc/init.d/openclash files/etc/rc.d/S99openclash

echo "✓ OpenClash auto-start script created"

echo "===================="
echo "DIY Part2 Script Finished"
echo "===================="

# Modify default IP
sed -i 's/192.168.1.1/192.168.25.1/g' package/base-files/files/bin/config_generate
