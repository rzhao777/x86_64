#!/bin/bash

# 1. 默认开启硬件流量加速 (HW NAT)
sed -i 's/option offload_routing .*/option offload_routing '\''1'\''/g' package/network/config/firewall/files/firewall.config
sed -i 's/option offload_hw .*/option offload_hw '\''1'\''/g' package/network/config/firewall/files/firewall.config

# 2. 修改默认管理 IP 为 GL.iNet 风格
sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate

# 3. 强制 SSH 配置为 2222 端口并禁用密码 (配合 .config)
sed -i 's/option Port .*/option Port '\''2222'\''/' package/base-files/files/etc/config/dropbear
sed -i 's/option PasswordAuth .*/option PasswordAuth '\''0'\''/' package/base-files/files/etc/config/dropbear

# 4. 让蓝色 LED 系统灯在启动完成后常亮
echo "echo '1' > /sys/class/leds/blue:system/brightness" >> package/base-files/files/etc/rc.local

# 5. 设置 CPU 为高性能模式 (MT7981 双核 1.3GHz)
echo "echo performance > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor" >> package/base-files/files/etc/rc.local
