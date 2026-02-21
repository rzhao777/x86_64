#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part3.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i "/helloworld/d" "feeds.conf.default"
#rm -rf feeds/packages/lang/golang
#git clone https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang
sed -i 's/src-git packages https:\/\/github.com\/openwrt\/packages.git/src-git packages https:\/\/github.com\/immortalwrt\/packages.git/g' feeds.conf.default
# Add a feed source
sed -i '1i src-git flrz https://github.com/flrz/openwrt-packages' feeds.conf.default
#sed -i '2i src-git immortalwrt_packages https://github.com/immortalwrt/packages' feeds.conf.default
#sed -i '2i src-git openclash https://github.com/vernesong/OpenClash' feeds.conf.default
#sed -i '1i src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '3i src-git small https://github.com/kenzok8/small' feeds.conf.default
#sed -i '3i src-git golang https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang' feeds.conf.default
#sed -i '3i src-git openwrt-passwall-packages https://github.com/flrz/openwrt-passwall-packages' feeds.conf.default
#sed -i '3i src-git passwall_packages https://github.com/flrz/passwall-packages' feeds.conf.default
#sed -i '4i src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall' feeds.conf.default
