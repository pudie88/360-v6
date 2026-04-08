# 🌐 OpenWrt for 360 V6 (Qualcomm IPQ60xx)

[![Build Status](https://github.com/${{ github.repository }}/actions/workflows/openwrt-builder.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/openwrt-builder.yml)
[![License](https://img.shields.io/badge/License-GPLv2-blue.svg)](https://www.gnu.org/licenses/gpl-2.0.html)
[![OpenWrt](https://img.shields.io/badge/OpenWrt-openwrt--24.10-00C7B7?logo=openwrt)](https://github.com/openwrt/openwrt)

> 🤖 基于 GitHub Actions 自动化编译的 OpenWrt **稳定版**固件，专为 **360 V6 (Qihoo 360V6)** 路由器定制。  
> ✅ 开箱即用：内置中文界面、轻量去广告、打印机共享与 HomeProxy，后续可通过 `opkg` 稳定按需扩展。

---

## 🖥️ 支持设备

| 设备型号 | SoC 平台 | 架构 | 闪存类型 | 适用镜像 |
|:---|:---|:---|:---|:---|
| **360 V6 (Qihoo 360V6)** | Qualcomm IPQ6018 | `aarch64_cortex-a53` | NAND | `*.ubi`, `*.itb` |

---

## ✨ 当前固件已内置功能

| 类别 | 插件/组件 | 说明 |
|:---|:---|:---|
| 🌐 **界面** | 默认简体中文 + Argon 主题 | 首次开机即为中文，支持浅色/深色模式 |
| 🛡️ **去广告** | `luci-app-adblock` | 官方轻量级 DNS 过滤，内存占用 < 15MB，规则每日自动更新 |
| 🧭 **科学上网** | `luci-app-homeproxy` + `sing-box` | 内置 GeoIP/GeoSite 数据库，开箱即用 |
| 🖨️ **打印共享** | `p910nd` + `kmod-usb-printer` | 支持 Canon MF4400 等 USB 打印机共享（需关闭 Windows 双向支持） |
| 💻 **管理工具** | TTYD 网页终端 | 无需 SSH 客户端，浏览器直接管理路由器 |
| 🔥 **网络核心** | `dnsmasq-full` + `firewall4` | 高性能 DNS/DHCP + 新版 nftables 防火墙 |

---

## 📦 刷入后「按需安装」命令清单（收藏备用）

> 💡 本固件基于 **`openwrt-24.10` 稳定版** 编译，`opkg` 软件源长期冻结，以下命令刷入后随时可执行，100% 匹配依赖。

```bash
# 🔁 第一步：更新软件包索引（建议每次安装前执行）
opkg update

# ==========================================
# 🛡️ 系统稳定性 & 网络增强
# ==========================================
# 网络看门狗：外网断线自动重启路由器（防半夜断网）
opkg install luci-app-watchcat

# 动态 DNS：支持阿里云/腾讯云/Cloudflare（远程管理必备）
opkg install luci-app-ddns ddns-scripts_aliyun ddns-scripts_dnspod ddns-scripts-cloudflare

# UPnP 自动端口映射：优化 PS5/Switch/NAT 类型，BT 下载提速
opkg install luci-app-upnp miniupnpd

# 定时重启：释放内存碎片（建议设置每周日凌晨 4:00）
opkg install luci-app-autoreboot

# ==========================================
# 📁 USB 存储 & 文件管理
# ==========================================
# 文件助手：网页端直接管理 U 盘/硬盘文件
opkg install luci-app-fileassistant

# SMB 局域网共享：将 U 盘/硬盘共享给 Windows/macOS/电视
opkg install luci-app-samba4 samba4-libs samba4-server

# ==========================================
# 🧩 其他实用工具（按需）
# ==========================================
# 系统状态增强面板
opkg install luci-app-status

# 更多主题（可选替换 Argon）
opkg install luci-theme-bootstrap luci-i18n-bootstrap-zh-cn

# 安装完成后刷新 LuCI 菜单
/etc/init.d/rpcd restart
