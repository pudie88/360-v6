# 🌐 OpenWrt for 360 V6 (Qualcomm IPQ60xx)

[](https://github.com/openwrt/openwrt)
[](https://www.google.com/search?q=https://github.com/%E4%BD%A0%E7%9A%84%E7%94%A8%E6%88%B7%E5%90%8D/%E4%BD%A0%E7%9A%84%E4%BB%93%E5%BA%93%E5%90%8D/actions)

> 🤖 **项目说明**：本固件专为 **360 V6** 路由器定制，基于 GitHub Actions 自动化编译。
> 核心理念：**轻量稳定、驱动完整、按需扩展**。内置常用核心插件，剩余空间留给用户自由发挥。

-----

## ✨ 固件核心特性

| 类别 | 插件/组件 | 功能说明 |
| :--- | :--- | :--- |
| 🎨 **界面** | Argon Theme | 默认简体中文，支持深色/浅色模式自动切换 |
| 🛡️ **拦截** | luci-app-adblock | 官方轻量化 DNS 过滤，保护全家设备免受广告干扰 |
| 🚀 **加速** | HomeProxy | 基于 `sing-box` 与 `nftables`，极致的网络中转性能 |
| 🖨️ **共享** | p910nd | 支持 USB 打印机网络共享，让老旧设备焕发新生 |
| 🛠️ **工具** | TTYD Terminal | 网页直接进入 SSH 命令行，无需额外客户端 |

-----

## 📦 扩展实验室：按需安装清单

> 💡 **操作指南**：通过 SSH 或 TTYD 进入后台，直接复制以下命令即可完成安装。

### 1\. 基础增强（推荐安装）

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

-----

### 2\. 存储与文件管理

**📁 网页文件管理器**

> 在浏览器端直接管理 U 盘文件，支持上传、下载及在线编辑。

```bash
opkg install luci-app-fileassistant
```

**📺 网络共享 (Samba4)**

> 将 U 盘变为局域网网盘，支持电视、电脑直接播放 U 盘电影。

```bash
opkg install luci-app-samba4
```

-----

### 3\. 电竞与极致网络

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

-----

## ⚠️ 重要说明

1.  **刷机前置**：请确保 360 V6 已开启 SSH 权限并刷入兼容的第三方 Bootloader。
2.  **打印机配置**：使用 `p910nd` 共享时，**必须**在 Windows 打印机属性中关闭“启用双向支持”。
## 📦 存储空间说明 (128MB NAND)

> 💡 本固件刷入后约剩余 **50~60MB** 可用空间，足够安装 10+ 个轻量插件。

### 🔧 如需更大空间？

1️⃣ **推荐**：下次编译时调整分区大小  
   修改工作流：`CONFIG_TARGET_ROOTFS_PARTSIZE=115` → 重新编译，零风险获得 +15MB

2️⃣ **灵活**：使用 USB 3.0 接口扩展  
   ```bash
   opkg install luci-app-diskman block-mount kmod-fs-ext4
   # 插入 U 盘后，LuCI → 磁盘管理 → 格式化为 ext4 → 挂载到 /ext_overlay
## 🛠️ 技术支持与致谢

  * **源码提供**: [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) / [OpenWrt](https://github.com/openwrt/openwrt)
  * **编译环境**: GitHub Actions
  * **特别鸣谢**: [P3TERX](https://github.com/P3TERX/Actions-OpenWrt)
