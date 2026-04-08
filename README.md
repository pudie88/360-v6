# 🌐 OpenWrt for 360 V6 (Qualcomm IPQ60xx)

[![OpenWrt](https://img.shields.io/badge/OpenWrt-24.10-00C7B7?logo=openwrt&logoColor=white)](https://github.com/openwrt/openwrt)
[![GitHub Release](https://img.shields.io/github/v/release/你的用户名/你的仓库名?color=blue&logo=github)](https://github.com/你的用户名/你的仓库名/releases)
[![License](https://img.shields.io/badge/License-GPL--3.0-orange)](LICENSE)

> 🤖 **自动化编译报告**：本固件专为 **360 V6 (Qihoo 360V6)** 定制。采用极简主义构建思路，仅内置核心驱动与高频插件，剩余空间通过 `opkg` 自由扩展，确保系统极致稳定与流畅。

---

## 🖥️ 硬件规格与镜像说明

| 属性 | 规格参数 | 备注 |
|:---|:---|:---|
| **SoC 平台** | Qualcomm IPQ6018 (4核 A53) | 强大的 Wi-Fi 6 处理能力 |
| **内存/闪存** | 512MB DDR3L / 128MB NAND | 建议使用 UBI 格式以获得最大空间 |
| **默认登录地址** | `192.168.1.1` | 首次进入无需密码，建议立即设置 |
| **默认账户** | `root` | 支持 SSH (Port 22) 与 TTYD 终端 |

---

## ✨ 固件核心特性（已内置）

| 功能模块 | 插件/组件 | 说明 |
|:---|:---|:---|
| 🎨 **UI 交互** | Argon Theme + 简体中文 | 适配移动端，支持暗黑模式自动切换 |
| 🛡️ **广告拦截** | `luci-app-adblock` | 官方轻量化 DNS 过滤，内存占用极低 (<15MB) |
| 🚀 **科学上网** | `HomeProxy` + `sing-box` | 基于 **nftables** 转发，支持 Hysteria2/TUIC v5 |
| 🖨️ **打印共享** | `p910nd` + `kmod-usb-printer` | 完美兼容 Canon/HP 等老旧打印机 (TCP 9100) |
| 🔥 **转发加速** | `Shortcut-FE` / `Flow Offload` | 充分发挥 IPQ6018 硬件转发性能，降低 CPU 占用 |
| 🛠️ **快捷维护** | TTYD Web Terminal | 浏览器一键进入后台命令行 |

---

## 📦 扩展实验室：按需安装清单

> 💡 **温馨提示**：本固件基于 **OpenWrt 24.10 稳定版** 源码编译，内核版本与软件源高度匹配，请放心执行以下命令。

### 1. 基础增强（推荐安装）
```bash
opkg update

网络看门狗：断网自动尝试重启网络或设备，适合无人值守环境
opkg install luci-app-watchcat

定时重启：每天凌晨自动清理缓存，长久运行不掉速
opkg install luci-app-autoreboot

动态 DNS (阿里/腾讯/Cloudflare)：外网访问路由器的必备神器
opkg install luci-app-ddns ddns-scripts_aliyun ddns-scripts_dnspod ddns-scripts_cloudflare
---

📦 扩展实验室：按需安装清单

> 💡 **温馨提示**：本固件基于 **OpenWrt 24.10 稳定版** 源码编译，内核版本与软件源高度匹配，请放心执行以下命令。

1. 基础增强（推荐安装）
```bash
opkg update
网络看门狗：断网自动尝试重启网络或设备，适合无人值守环境
opkg install luci-app-watchcat

定时重启：每天凌晨自动清理缓存，长久运行不掉速
opkg install luci-app-autoreboot

动态 DNS (阿里/腾讯/Cloudflare)：外网访问路由器的必备神器
opkg install luci-app-ddns ddns-scripts_aliyun ddns-scripts_dnspod ddns-scripts_cloudflare
```

2. 娱乐与存储（360 V6 USB口妙用）
```bash
文件管理器：在网页端直接上传、下载、修改 U 盘文件
opkg install luci-app-fileassistant
 网络共享 (Samba4)：让电视、电脑直接访问 U 盘里的电影
opkg install luci-app-samba4


3. 电竞与极致网络
```bash
UPnP：优化游戏机 (PS5/Switch) NAT 类型，提升联机成功率
opkg install luci-app-upnp

SQM 流量管理：多人抢网时保证游戏延迟依然稳定 (防止 Bufferbloat)
opkg install luci-app-sqm

## ⚠️ 注意事项

1. **首次刷入**：请确保您已通过 SSH 开启了 360 V6 的原厂权限并刷入了兼容的 Bootloader。
2. **分区扩容**：本固件默认分区表适配官方布局。如需利用剩余闪存空间，请在刷入后通过 `Diskman` 挂载或自行调整分区。
3. **打印机配置**：使用 `p910nd` 时，请务必在 Windows 端打印机属性中**取消勾选“启用双向支持”**，否则可能无法正常打印。


## 🛠️ 开发与贡献

* **固件源码**: [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) / [OpenWrt Official](https://github.com/openwrt/openwrt)
* **编译工具**: GitHub Actions
* **特别感谢**: P3TERX (Actions-OpenWrt)
