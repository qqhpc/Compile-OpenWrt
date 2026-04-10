#!/bin/bash

# 描述：OpenWrt DIY 脚本第 1 部分（更新 feed 之前）

# helloworld
sed -i "/helloworld/d" "feeds.conf.default" && git clone https://github.com/fw876/helloworld.git ./package/luci-app-ssr-plus
# homeproxy
git clone https://github.com/immortalwrt/homeproxy.git ./package/luci-app-homeproxy
# depends
git clone https://github.com/xiaorouji/openwrt-passwall-packages.git ./package/passwall-depends


./scripts/feeds update -a
./scripts/feeds install -a && ./scripts/feeds install -a -f
