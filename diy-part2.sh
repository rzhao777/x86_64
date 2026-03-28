#!/bin/bash
# diy-part2.sh
# OpenClash + Mihomo x86_64 Clash Meta Alpha
# 自动获取最新 Pre-release 内核 + 默认配置 + 开机启动

set -e

echo "===================="
echo "DIY Part2 Script Start"
echo "===================="

cd "$GITHUB_WORKSPACE/openwrt"

# -----------------------
# 1️⃣ 创建 OpenClash 配置目录
# -----------------------
mkdir -p files/usr/bin files/etc/openclash files/etc/init.d

# -----------------------
# 2️⃣ 默认配置
# -----------------------
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
# 3️⃣ 安装 LuCI OpenClash 插件
# -----------------------
grep -q "openclash" feeds.conf.default || \
    echo "src-git openclash https://github.com/vernesong/OpenClash.git" >> feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -a luci-app-openclash

echo "✓ OpenClash feed and LuCI plugin installed"

# -----------------------
# 4️⃣ 开机自动启动 + 自动更新 Alpha 内核
# -----------------------
cat > files/etc/init.d/openclash << 'EOF'
#!/bin/sh /etc/rc.common
START=99
STOP=10

CLASH_BIN="/usr/bin/clash_meta"
CLASH_DIR="/etc/openclash"
TMP_BIN="/tmp/clash_meta_new"

# GitHub API 获取最新 Pre-release 下载 URL
get_latest_alpha() {
    curl -s https://api.github.com/repos/Mihoho/OpenClash_Core/releases \
    | grep -E '"tag_name":|"browser_download_url":' \
    | grep -B1 'clash_meta_amd64.gz' \
    | grep '"browser_download_url":' \
    | head -n1 \
    | cut -d '"' -f4
}

start() {
    echo "Starting OpenClash..."

    # 获取最新 Alpha 内核 URL
    UPDATE_URL=$(get_latest_alpha)
    if [ -n "$UPDATE_URL" ]; then
        echo "Latest Alpha core URL: $UPDATE_URL"
        curl -sL "$UPDATE_URL" | gunzip -c > $TMP_BIN
        if [ -f "$TMP_BIN" ]; then
            chmod +x $TMP_BIN
            cmp -s $TMP_BIN $CLASH_BIN || {
                echo "New Alpha core detected, updating..."
                mv $TMP_BIN $CLASH_BIN
                chmod +x $CLASH_BIN
                echo "✓ Alpha core updated"
            }
        fi
    fi

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

echo "✓ OpenClash auto-start and auto-update script created"

echo "===================="
echo "DIY Part2 Script Finished"
echo "===================="

# Modify default IP
sed -i 's/192.168.1.1/192.168.25.1/g' package/base-files/files/bin/config_generate
