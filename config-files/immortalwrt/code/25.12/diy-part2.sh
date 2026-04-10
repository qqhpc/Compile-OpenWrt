#!/bin/bash
#========================================================================================================================

# 把root的空密码改为password
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# 修改 etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='official'" >>package/base-files/files/etc/openwrt_release

# 修改默认IP(由 192.168.1.1 改成 192.168.60.2)
sed -i 's/192.168.1.1/192.168.60.2/g' package/base-files/files/bin/config_generate
#
