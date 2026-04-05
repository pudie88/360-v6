#!/bin/bash
set -e

cd "$GITHUB_WORKSPACE/openwrt"

echo ">>> 克隆 PassWall"
if [ ! -d "package/luci-app-passwall" ]; then
    git clone --depth 1 \
        https://github.com/xiaorouji/openwrt-passwall \
        package/luci-app-passwall
fi

echo ">>> 克隆 AdGuardHome"
if [ ! -d "package/luci-app-adguardhome" ]; then
    git clone --depth 1 \
        https://github.com/rufengsuixing/luci-app-adguardhome \
        package/luci-app-adguardhome
fi

echo ">>> 克隆 Argon 主题"
rm -rf package/lean/luci-theme-argon 2>/dev/null || true
if [ ! -d "package/luci-theme-argon" ]; then
    git clone --depth 1 -b master \
        https://github.com/jerrykuku/luci-theme-argon \
        package/luci-theme-argon
fi

# ⚠️ 移除 MosDNS（高通版本可能兼容性差）
# echo ">>> 克隆 MosDNS"  # 已注释

# ⚠️ 移除 OpenClash（体积大 + 与 PassWall 冲突）
# echo ">>> 克隆 OpenClash"  # 已注释

echo ">>> DIY 脚本执行完成"
