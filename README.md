# 🌐 OpenWrt for 360 V6 (Qualcomm IPQ60xx)

[![OpenWrt](https://img.shields.io/badge/OpenWrt-24.10-00C7B7?logo=openwrt&logoColor=white)](https://github.com/openwrt/openwrt)
[![License](https://img.shields.io/badge/License-GPLv2-blue.svg)](https://www.gnu.org/licenses/gpl-2.0.html)

自动构建适用于 **奇虎 360 V6** 路由器的 OpenWrt 固件，基于 GitHub Actions 全自动编译。

> 🤖 **项目说明**：本固件专为 360 V6 定制。核心理念：**轻量稳定、驱动完整、按需扩展**。内置常用核心插件，剩余空间留给用户自由发挥。

---

## 🛠️ 固件当前编译状态 (内置功能)

| 类别 | 状态 | 组件说明 |
| :--- | :--- | :--- |
| 🎨 **界面** | ✅ 已内置 | Argon 主题 + 完整简体中文包 (`zh-cn`) |
| 🚀 **代理** | ✅ 已内置 | HomeProxy + sing-box 核心 + nftables 硬件转发 |
| 📶 **无线** | ✅ 已内置 | ath11k 驱动 + QCN9074 固件 (支持 Wi-Fi 6) |
| 🔌 **硬件** | ✅ 已内置 | USB 3.0 控制器驱动 (`kmod-usb-dwc3`) |
| 🛠️ **终端** | ✅ 已内置 | TTYD 网页终端 (支持中文输入) |
| 🔥 **防火墙** | ✅ 已内置 | dnsmasq-full + firewall4 + nftables |

---

## 📦 扩展实验室：按需安装清单 (100% 兼容)

> 💡 **操作指南**：通过 TTYD 或 SSH 进入后台，直接复制粘贴以下命令即可。
> ✅ 本固件基于 **OpenWrt 24.10 稳定版** 编译，软件源长期冻结，依赖完全匹配。

### 0. 准备工作
```bash
opkg update
````

### 1\. 🛡️ 去广告 (官方轻量级)

> DNS 层过滤，内存占用 \< 15MB，规则每日自动更新。

```bash
opkg install luci-app-adblock luci-i18n-adblock-zh-cn
```

### 2\. 🖨️ USB 打印机共享

> 适配 Canon/HP 等 USB 打印机。注意：Windows 配置时必须 **关闭「启用双向支持」**。

```bash
opkg install kmod-usb-printer p910nd luci-app-p910nd luci-i18n-p910nd-zh-cn
```

### 3\. 📁 USB 存储与文件管理

```bash
# 安装文件管理器与 Samba 共享
opkg install luci-app-fileassistant luci-app-samba4 luci-i18n-samba4-zh-cn
```

### 4\. 🛠️ 系统增强

```bash
# 网络看门狗（断网自动重启）
opkg install luci-app-watchcat
# 动态 DNS（支持阿里/腾讯/Cloudflare）
opkg install luci-app-ddns ddns-scripts_aliyun ddns-scripts_dnspod ddns-scripts-cloudflare
# UPnP（优化游戏 NAT 类型）
opkg install luci-app-upnp luci-i18n-upnp-zh-cn
```

-----

## ⬇️ 下载固件

前往 [Releases](https://www.google.com/search?q=../../releases) 页面下载最新版本。

| 文件后缀 | 用途 |
|:---|:---|
| `*-factory.ubi` | **首次刷入**（从原厂固件/救砖模式刷入） |
| `*-sysupgrade.bin` | **已有 OpenWrt** 时升级使用 |

-----

## 🔧 刷机说明

### 首次刷入 (原厂系统/救砖)

1.  通过 TTL 串口或 TFTP 进入 U-Boot 恢复模式。
2.  刷入 `*-factory.ubi` 镜像至对应分区。
3.  等待重启完成后，访问 `192.168.1.1`。

### 升级 OpenWrt

1.  登录 LuCI 管理界面 → 系统 → 备份/升级。
2.  上传 `*-sysupgrade.bin` 文件。
3.  勾选 `保留配置`（可选）→ 点击 `刷写固件` 等待重启。

### 默认信息

  - **管理地址**：`http://192.168.1.1`
  - **用户名**：`root`
  - **密码**：**（空，直接回车）**

-----

## 📋 设备硬件信息

| 项目 | 参数 |
|------|------|
| 设备名称 | 奇虎 360 V6 (Qihoo 360V6) |
| SoC | Qualcomm IPQ6018 (4核 A53) |
| 内存 | 512MB DDR3L |
| 闪存 | 128MB NAND |
| 接口 | 1 x WAN + 3 x LAN (千兆) / 1 x USB 3.0 |

-----

## ⚠️ 免责声明

刷机有风险，操作需谨慎。本固件及 README 内容结合 AI 辅助生成，仅供学习交流使用。因刷机导致的设备损坏或数据丢失，作者概不负责。请遵守当地法律法规，合理使用网络资源。

-----

💡 **Star ⭐ 本仓库** 以获取更新通知 | 🐛 遇到问题请提交 [Issues](https://www.google.com/search?q=../../issues)

```
```
