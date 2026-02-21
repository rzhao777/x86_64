#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# 1. 删除当前 feeds 中的旧版 golang
#rm -rf feeds/packages/lang/golang
# 2. 从 ImmortalWrt 仓库拉取最新的 golang 定义
#git clone https://github.com/immortalwrt/packages.git /tmp/immortalwrt_pkg
#cp -rf /tmp/immortalwrt_pkg/lang/golang feeds/packages/lang/golang
# 3. 清理临时文件
#rm -rf /tmp/immortalwrt_pkg

# Modify default IP
sed -i 's/192.168.1.1/192.168.6.9/g' package/base-files/files/bin/config_generate
