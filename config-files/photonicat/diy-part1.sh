#!/bin/bash

# 描述：OpenWrt DIY 脚本第 1 部分（更新 feed 之前）

# helloworld
sed -i "/helloworld/d" "feeds.conf.default" && git clone https://github.com/fw876/helloworld.git ./package/luci-app-ssr-plus
# homeproxy
git clone https://github.com/immortalwrt/homeproxy.git ./package/luci-app-homeproxy
# depends
git clone https://github.com/xiaorouji/openwrt-passwall-packages.git ./package/passwall-depends

# Install feeds packages
./scripts/feeds update -a
./scripts/feeds install -a && ./scripts/feeds install -a -f

# Update go
# git clone https://github.com/openwrt/packages.git ../packages
# rm -rf ./feeds/packages/lang/golang && cp -R ../packages/lang/golang ./feeds/packages/lang/golang
# rm -rf ../packages

# Install vlmcsd
./scripts/feeds update -a
./scripts/feeds install -a && ./scripts/feeds install -a -f
