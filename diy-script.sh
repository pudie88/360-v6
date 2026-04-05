#!/bin/bash
set -e
cd "$GITHUB_WORKSPACE/openwrt"

echo ">>> Installing PassWall"
[ ! -d "package/luci-app-passwall" ] && \
  mkdir -p package/luci-app-passwall && \
  curl -L -s https://github.com/xiaorouji/openwrt-passwall/archive/refs/heads/main.tar.gz | \
    tar -xzf - -C package/luci-app-passwall --strip-components=1

# ✅ kenzok8 fork — rufengsuixing is abandoned
echo ">>> Installing AdGuardHome"
[ ! -d "package/luci-app-adguardhome" ] && \
  mkdir -p package/luci-app-adguardhome && \
  curl -L -s https://github.com/kenzok8/luci-app-adguardhome/archive/refs/heads/master.tar.gz | \
    tar -xzf - -C package/luci-app-adguardhome --strip-components=1

echo ">>> Installing Argon theme"
rm -rf package/lean/luci-theme-argon 2>/dev/null || true
[ ! -d "package/luci-theme-argon" ] && \
  mkdir -p package/luci-theme-argon && \
  curl -L -s https://github.com/jerrykuku/luci-theme-argon/archive/refs/heads/master.tar.gz | \
    tar -xzf - -C package/luci-theme-argon --strip-components=1

echo ">>> DIY script complete"
