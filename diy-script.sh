#!/bin/bash
# ==================================================
# DIY 脚本：安装第三方插件
# 在 feeds update/install 之前执行
# ==================================================
set -e

cd "$GITHUB_WORKSPACE/openwrt"

# 通用下载函数
gh_download() {
  local url="$1"
  local dest="$2"
  local tmp
  tmp=$(mktemp /tmp/pkg_XXXXXX.tar.gz)

  echo ">>> 下载: $url"
  curl -L -s \
    --retry 3 \
    --retry-delay 5 \
    -H "User-Agent: Mozilla/5.0 (GitHub Actions OpenWrt Builder)" \
    -o "$tmp" \
    "$url"

  if ! file "$tmp" | grep -q "gzip compressed"; then
    echo "❌ 下载失败，收到的不是 gzip 文件，实际内容："
    head -5 "$tmp"
    rm -f "$tmp"
    return 1
  fi

  mkdir -p "$dest"
  tar -xzf "$tmp" -C "$dest" --strip-components=1
  rm -f "$tmp"
  echo "✅ 安装完成: $dest"
}

# PassWall 本体
gh_download \
  "https://github.com/xiaorouji/openwrt-passwall/archive/refs/heads/main.tar.gz" \
  "package/luci-app-passwall"

# PassWall 依赖包
gh_download \
  "https://github.com/xiaorouji/openwrt-passwall-packages/archive/refs/heads/main.tar.gz" \
  "package/passwall-packages"

# AdGuardHome
gh_download \
  "https://github.com/kenzok8/luci-app-adguardhome/archive/refs/heads/master.tar.gz" \
  "package/luci-app-adguardhome"

# Argon 主题
rm -rf package/lean/luci-theme-argon 2>/dev/null || true
gh_download \
  "https://github.com/jerrykuku/luci-theme-argon/archive/refs/heads/master.tar.gz" \
  "package/luci-theme-argon"

echo ">>> DIY 脚本执行完成"
