#!/bin/bash

# 描述：OpenWrt DIY 脚本第 1 部分（更新 feed 之前）

# passwall
git clone https://github.com/xiaorouji/openwrt-passwall.git ./package/luci-app-passwall
# helloworld
sed -i "/helloworld/d" "feeds.conf.default" && git clone https://github.com/fw876/helloworld.git ./package/luci-app-ssr-plus
# openclash
git clone --branch master --depth=1 https://github.com/vernesong/OpenClash.git ./package/luci-app-openclash
# homeproxy
git clone https://github.com/immortalwrt/homeproxy.git ./package/luci-app-homeproxy
# depends
git clone https://github.com/xiaorouji/openwrt-passwall-packages.git ./package/passwall-depends


# Install vlmcsd
git clone https://github.com/immortalwrt/packages.git ../packages
git clone https://github.com/immortalwrt/luci.git ../luci
cp -R ../packages/net/vlmcsd ./feeds/packages/net/vlmcsd
cp -R ../luci/applications/luci-app-vlmcsd ./feeds/luci/applications/luci-app-vlmcsd
rm -rf ../packages
rm -rf ../luci
./scripts/feeds update -a
./scripts/feeds install -a && ./scripts/feeds install -a -f
