#!/bin/bash

# 描述：OpenWrt DIY 脚本第 1 部分(更新 feed 之前)

# luci-app-passwall
git clone -q --depth=1 --branch=main --single-branch https://github.com/Openwrt-Passwall/openwrt-passwall.git ./package/luci-app-passwall

# luci-app-passwall2
git clone -q --depth=1 --branch=main --single-branch https://github.com/Openwrt-Passwall/openwrt-passwall2.git ./package/luci-app-passwall2

# luci-app-ssr-plus
sed -i "/helloworld/d" "feeds.conf.default" && git clone -q --depth=1 --branch=master --single-branch https://github.com/fw876/helloworld.git ./package/luci-app-ssr-plus

# passwall-depends
git clone -q --depth=1 --branch=main --single-branch https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git ./package/passwall-depends

# luci-app-openclash
git clone -q --depth=1 --branch=master --single-branch https://github.com/vernesong/OpenClash.git ./package/luci-app-openclash

# luci-app-homeproxy
git clone -q --depth=1 --branch=master --single-branch https://github.com/immortalwrt/homeproxy.git ./package/luci-app-homeproxy

# 更新 go

git clone -q --depth=1 --branch=master --single-branch https://github.com/openwrt/packages.git /tmp/packages
rm -rf ./feeds/packages/lang/golang && cp -R /tmp/packages/lang/golang ./feeds/packages/lang/golang
rm -rf /tmp/packages

# luci-app-vlmcsd
git clone -q --depth=1 --branch=master --single-branch https://github.com/immortalwrt/packages.git /tmp/immortalwrt-packages
git clone -q --depth=1 --branch=master --single-branch https://github.com/immortalwrt/luci.git /tmp/immortalwrt-luci
cp -R /tmp/immortalwrt-packages/net/vlmcsd ./feeds/packages/net/vlmcsd && cp -R /tmp/immortalwrt-luci/applications/luci-app-vlmcsd ./feeds/luci/applications/luci-app-vlmcsd
rm -rf /tmp/immortalwrt-packages && rm -rf /tmp/immortalwrt-luci

# 安装 feeds 因为又添加了 luci-app-vlmcsd
./scripts/feeds update -a
./scripts/feeds install -a
