#!/bin/bash

# 确保 Dropbear 默认配置中关闭密码登录 (双重保险)
# 1. 设置端口为 2222
# 2. 禁用密码验证
# 3. 禁用 Root 密码登录
sed -i 's/option Port .*/option Port '\''2222'\''/' package/base-files/files/etc/config/dropbear
sed -i 's/option PasswordAuth .*/option PasswordAuth '\''0'\''/' package/base-files/files/etc/config/dropbear
sed -i 's/option RootPasswordAuth .*/option RootPasswordAuth '\''0'\''/' package/base-files/files/etc/config/dropbear

# 修正目录权限 (确保 SSH 密钥能被正确读取)
chmod 700 package/base-files/files/etc/dropbear || true
chmod 600 package/base-files/files/etc/dropbear/authorized_keys || true
# 创建侧边开关脚本示例 (当开关拨动时执行)
mkdir -p package/base-files/files/etc/hotplug.d/button
cat <<EOF > package/base-files/files/etc/hotplug.d/button/01-radio-toggle
#!/bin/sh
[ "\$BUTTON" = "BTN_0" ] || exit 0
[ "\$ACTION" = "pressed" ] && /etc/init.d/openclash start
[ "\$ACTION" = "released" ] && /etc/init.d/openclash stop
EOF
# 默认开启硬件流量卸载
sed -i 's/option offload_routing .*/option offload_routing '\''1'\''/g' package/network/config/firewall/files/firewall.config
sed -i 's/option offload_hw .*/option offload_hw '\''1'\''/g' package/network/config/firewall/files/firewall.config
