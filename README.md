# 🌐 OpenWrt for 360 V6 (Qualcomm IPQ60xx)

[![OpenWrt](https://img.shields.io/badge/OpenWrt-24.10-00C7B7?logo=openwrt&logoColor=white)](https://github.com/openwrt/openwrt)
[![Actions](https://img.shields.io/badge/Actions-AutoBuild-blue?logo=githubactions&logoColor=white)](https://github.com/${{ github.repository }}/actions)
[![License](https://img.shields.io/badge/License-GPLv2-blue.svg)](https://www.gnu.org/licenses/gpl-2.0.html)

> 🤖 **项目说明**：本固件专为 **360 V6** 路由器定制，基于 GitHub Actions 自动化编译。  
> 核心理念：**轻量稳定、驱动完整、按需扩展**。内置常用核心插件，剩余空间留给用户自由发挥。

---

## 🔑 默认登录信息

| 项目 | 值 |
|:---|:---|
| 🌐 管理地址 | `192.168.1.1` |
| 👤 用户名 | `root` |
| 🔑 密码 | **空**（首次登录请务必设置密码） |
| 📶 默认 Wi-Fi | 未预设，请登录后在 `网络 → 无线` 中手动配置 |

---

## ✨ 固件核心特性

| 类别 | 插件/组件 | 功能说明 |
| :--- | :--- | :--- |
| 🎨 **界面** | Argon Theme | 默认简体中文，支持深色/浅色模式自动切换 |
| 🛡️ **拦截** | luci-app-adblock | 官方轻量化 DNS 过滤，保护全家设备免受广告干扰 |
| 🚀 **加速** | HomeProxy | 基于 `sing-box` 与 `nftables`，极致的网络中转性能 |
| 🖨️ **共享** | p910nd | 支持 USB 打印机网络共享，让老旧设备焕发新生 |
| 🛠️ **工具** | TTYD Terminal | 网页直接进入 SSH 命令行，无需额外客户端 |

---

## 📦 扩展实验室：按需安装清单

> 💡 **操作指南**：通过 SSH 或 TTYD 进入后台，直接复制以下命令即可完成安装。  
> ✅ 本固件基于 **OpenWrt 24.10 稳定版** 编译，`opkg` 源长期有效，依赖 100% 匹配。

### 1. 基础增强（推荐安装）

**🔁 更新软件包索引**
```bash
opkg update
```

**🛡️ 网络看门狗**
> 断网后自动检测并重启网络或路由器，适合无人值守环境。
```bash
opkg install luci-app-watchcat
```

**⏰ 定时重启**
> 建议设置每周凌晨自动重启，保持系统长久运行不掉速。
```bash
opkg install luci-app-autoreboot
```

**☁️ 动态 DNS (DDNS)**
> 外网访问必备！支持阿里云、腾讯云 DNSPod 及 Cloudflare。
```bash
opkg install luci-app-ddns ddns-scripts_aliyun ddns-scripts_dnspod ddns-scripts-cloudflare
```

---

### 2. 存储与文件管理

**📁 网页文件管理器**
> 在浏览器端直接管理 U 盘文件，支持上传、下载及在线编辑。
```bash
opkg install luci-app-fileassistant
```

**📺 网络共享 (Samba4)**
> 将 U 盘变为局域网网盘，支持电视、电脑直接播放 U 盘电影。
```bash
opkg install luci-app-samba4 samba4-libs
```

---

### 3. 电竞与极致网络

**🎮 UPnP 自动映射**
> 优化 PS5/Switch/Xbox 联机体验，提升 NAT 类型和下载速度。
```bash
opkg install luci-app-upnp
```

**🚀 SQM 流量管理**
> 多人抢网不掉线，有效解决网络延迟波动（Bufferbloat）。
```bash
opkg install luci-app-sqm
```

---

## 📦 存储空间说明 (128MB NAND)

> 💡 **实际情况**：本固件刷入后约剩余 **50~60MB** 可用空间，足够安装 10+ 个轻量插件（adblock / watchcat / ddns 等）。

### 🔧 如需更大空间？

| 方案 | 操作 | 风险 | 推荐度 |
|:---|:---|:---|:---|
| **编译时增大分区** | 修改工作流 `CONFIG_TARGET_ROOTFS_PARTSIZE=115` | ⭐ 零风险 | 🥇 首选 |
| **USB 3.0 扩展** | 插入 U 盘 → LuCI → 挂载为 `/ext_overlay` | ⭐ 零风险 | 🥈 推荐 |
| ❌ **NAND 手动分区** | 用 diskman/fdisk 操作内置闪存 | 🔴 极高（易变砖） | ❌ 不推荐 |

#### ✅ 方案 1：下次编译时调整（推荐）
只需修改工作流中一行配置，零风险获得额外可用空间：
```yaml
echo "CONFIG_TARGET_ROOTFS_PARTSIZE=115"  # 原默认为 100
```

#### ✅ 方案 2：使用 USB 3.0 接口扩展（灵活）
```bash
# 1. 安装必要组件
opkg install luci-app-diskman block-mount kmod-fs-ext4 kmod-usb-storage

# 2. 插入 U 盘，登录 LuCI → 磁盘管理
#    → 选择 U 盘 → 格式化为 ext4 → 挂载点设为 /ext_overlay → 启用

# 3. (可选) 将 /overlay 软链接到 U 盘（高级）
#    需谨慎操作，建议参考官方文档
```
> 💡 64GB U 盘仅需 ¥30，空间「无限」扩展，拔掉即恢复原厂状态，安全灵活。

> ⚠️ **重要警告**：360 V6 的 NAND 分区由厂商预定义。**请勿尝试用网页工具格式化内置 NAND 分区**，操作失误可能导致设备无法启动，需拆机用编程器救砖。

---

## 📥 刷机指南

### 🟢 情况一：已在运行 OpenWrt
1. 登录 LuCI → `系统` → `备份/升级`
2. 上传 `openwrt-qualcommax-ipq60xx-qihoo_360v6-squashfs-sysupgrade.bin`（或对应 `.ubi` 镜像）
3. 勾选 `保留配置`（如需）→ 点击 `刷写固件` 等待重启

### 🔴 情况二：原厂系统 / 救砖模式
1. 通过 TTL 串口或 TFTP 进入 U-Boot/恢复模式
2. 刷入 `*.itb` (FIT Image) 或 `*.ubi` 镜像至对应分区
3. 重启后通过 `192.168.1.1` 访问 LuCI 完成初始化

---

## ⚠️ 重要注意事项

- **打印机共享**：使用 `p910nd` 共享时，**必须在 Windows 打印机属性中关闭「启用双向支持」**，否则易出现队列卡死。
- **去广告兼容**：`adblock` 与 `mosdns`/`AdGuard Home` 功能重叠且可能冲突，**请勿同时启用多个 DNS 过滤插件**。
- **内存管理**：360 V6 为 512MB RAM。内置插件已优化。若自行安装 Docker 等重型服务，请密切监控 `状态 → 内存`，避免 OOM 死机。
- **硬件差异**：360 V6 存在不同批次，若刷机后无法启动，请核对设备闪存类型（NAND）与分区表是否匹配。

---

## 🙏 致谢

- [OpenWrt Project](https://github.com/openwrt/openwrt) – 核心源码与构建系统
- [ImmortalWrt](https://github.com/immortalwrt/homeproxy) – HomeProxy 插件支持
- [jerrykuku](https://github.com/jerrykuku/luci-theme-argon) – Argon 主题
- [P3TERX](https://github.com/P3TERX/Actions-OpenWrt) – Actions 编译方案参考

---

## 📜 免责声明

本项目仅供学习与研究使用，代码和 README 均结合 AI 生成，编译的固件不包含任何商业授权或担保。  
使用本固件即表示您同意自行承担所有风险，作者不对因刷机、配置或使用本固件导致的任何设备损坏、数据丢失或网络问题负责。
