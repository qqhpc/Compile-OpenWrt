#!/bin/bash

# 当任何命令失败时立即退出
set -e

# ================== 可配置项 ==================
# 你的 .config 文件下载地址。请替换成你自己的 URL。
# 例如，可以上传到 GitHub Gist 或任何可以直链下载的地方。
CONFIG_FILE_URL="https://raw.githubusercontent.com/qqhpc/openwrt/refs/heads/main/config-files/openwrt-24.10/x86/config"

# 编译使用的CPU核心数，建议是您宿主机CPU核心数+1
MAKE_J_LEVEL=$(($(nproc) + 1))
# ============================================

echo "================================================="
echo "==> 1. 开始更新和安装依赖..."
echo "================================================="
# 依赖已在 Dockerfile 中安装，此处无需操作


echo "================================================="
echo "==> 2. 拉取 OpenWrt 官方源码..."
echo "================================================="
git clone -b openwrt-24.10 https://git.openwrt.org/openwrt/openwrt.git openwrt-guanfang
cd openwrt-guanfang


echo "================================================="
echo "==> 3. 添加自定义插件..."
echo "================================================="
# Passwall
git clone https://github.com/xiaorouji/openwrt-passwall.git ./package/luci-app-passwall
git clone https://github.com/xiaorouji/openwrt-passwall-packages.git ./package/passwall-depends

# SSR-Plus
sed -i "/helloworld/d" "feeds.conf.default"
git clone https://github.com/fw876/helloworld.git ./package/luci-app-ssr-plus

# OpenClash
git clone --branch dev --depth=1 https://github.com/vernesong/OpenClash.git ./package/luci-app-openclash

# HomeProxy
git clone https://github.com/immortalwrt/homeproxy.git ./package/luci-app-homeproxy


echo "================================================="
echo "==> 4. 第一次更新 feeds..."
echo "================================================="
./scripts/feeds update -a
./scripts/feeds install -a


echo "================================================="
echo "==> 5. 更新 Go 语言 & 添加 vlmcsd..."
echo "================================================="
# 使用临时目录，避免污染主工作区
git clone https://github.com/openwrt/packages.git ../packages
git clone https://github.com/immortalwrt/luci.git ../luci
git clone https://github.com/immortalwrt/packages.git ../immortalwrt-packages

echo "--> 更新 Go..."
rm -rf ./feeds/packages/lang/golang
cp -R ../packages/lang/golang ./feeds/packages/lang/golang

echo "--> 添加 vlmcsd..."
cp -R ../immortalwrt-packages/net/vlmcsd ./feeds/packages/net/vlmcsd
cp -R ../luci/applications/luci-app-vlmcsd ./feeds/luci/applications/luci-app-vlmcsd

echo "--> 清理临时克隆..."
rm -rf ../packages
rm -rf ../luci
rm -rf ../immortalwrt-packages

echo "================================================="
echo "==> 6. 第二次更新 feeds..."
echo "================================================="
./scripts/feeds update -a
./scripts/feeds install -a


echo "================================================="
echo "==> 7. 下载并应用自定义 .config 文件..."
echo "================================================="
wget -O .config ${CONFIG_FILE_URL}
make defconfig


echo "================================================="
echo "==> 8. 下载 DL 库..."
echo "================================================="
# -j1 确保单线程下载，提高成功率
make download -j1 V=s
make download -j1


echo "================================================="
echo "==> 9. 开始编译固件 (make V=s -j$(nproc)) ..."
echo "================================================="
# 使用 V=s 模式输出详细日志，-j 指定多核编译
# 首次编译建议用 -j1 单线程，保证成功率。成功后可改为多线程。
make V=s -j1
# 如果单线程编译成功，下次可以注释掉上一行，使用下面这行来加速编译
# make V=s -j${MAKE_J_LEVEL}


echo "================================================="
echo "==> 编译完成！固件已生成在 bin/ 目录中。"
echo "==> 容器将自动停止。"
echo "================================================="