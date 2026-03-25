#!/bin/bash

# 1. 开启硬件流量加速 (使用更稳妥的匹配方式)
# 注意：有些版本默认没有这些行，建议先删除再追加或使用覆盖模式
FW_CFG="package/network/config/firewall/files/firewall.config"
if [ -f "$FW_CFG" ]; then
    sed -i '/option offload_routing/d' $FW_CFG
    sed -i '/option offload_hw/d' $FW_CFG
    sed -i '/config defaults/a \	option offload_routing '\''1'\''\n	option offload_hw '\''1'\''' $FW_CFG
fi

# 2. 修改默认管理 IP (192.168.1.1 -> 192.168.8.1)
sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate

# 3. SSH 安全配置 (端口 2222，禁用密码)
# 注意：dropbear 的默认文件可能只有部分选项，建议直接修改或确保存在
DB_CFG="package/base-files/files/etc/config/dropbear"
if [ -f "$DB_CFG" ]; then
    sed -i "s/option Port '22'/option Port '2222'/g" $DB_CFG
    sed -i "s/option PasswordAuth 'on'/option PasswordAuth 'off'/g" $DB_CFG
    # 如果不存在 PasswordAuth 选项则追加
    grep -q "PasswordAuth" $DB_CFG || sed -i "/config dropbear/a \	option PasswordAuth '0'" $DB_CFG
fi

# 4 & 5. 启动脚本 (LED 和 CPU 性能)
# 使用 sed 在 exit 0 之前插入，确保脚本一定能执行
RC_LOCAL="package/base-files/files/etc/rc.local"
sed -i '/exit 0/i # 设置蓝色 LED 常亮\necho 1 > /sys/class/leds/blue:system/brightness\n' $RC_LOCAL
sed -i '/exit 0/i # 设置 CPU 高性能模式\necho performance > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor\n' $RC_LOCAL
