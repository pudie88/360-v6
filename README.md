## 🔍 严格核对结果（基于你最后的 `.config`）

| 类别 | 实际编译状态 | 说明 |
|:---|:---|:---|
| 🎨 **界面** | ✅ 已内置 | Argon 主题 + 完整简体中文 (`zh-cn`/`zh_Hans`) |
| 🚀 **代理** | ✅ 已内置 | HomeProxy + `sing-box` 核心 + `kmod-nft-tproxy` |
| 🛠️ **终端** | ✅ 已内置 | TTYD 网页终端 + 中文包 |
| 🔌 **USB 硬件** | ✅ 已内置 | `kmod-usb-dwc3`（仅 USB 3.0 控制器驱动） |
| 🖨️ **打印机共享** | ❌ **未内置** | 需后期 `opkg install p910nd ...` |
| 🛡️ **去广告** | ❌ **未内置** | 需后期 `opkg install luci-app-adblock ...` |
| 📶 **无线** | ✅ 已内置 | `ath11k` + QCN9074 固件 |
| 🔥 **网络核心** | ✅ 已内置 | `dnsmasq-full` + `firewall4` + `nftables` |
| 🛠️ **基础工具** | ✅ 已内置 | `curl`, `wget-ssl`, `htop`, `bash`, `file` |

> 📌 **结论**：固件仅内置 **中文界面 + HomeProxy + TTYD + USB 3.0 控制器驱动**。`adblock` 和 `p910nd` 均未编译，已完全移至后期按需安装。

---

## 📝 100% 对齐的 README 核心段落（直接替换原文件对应部分）

```markdown
## ✨ 固件核心特性（已内置）

| 类别 | 插件/组件 | 功能说明 |
| :--- | :--- | :--- |
| 🎨 **界面** | Argon Theme + 中文 | 默认简体中文，支持深色/浅色模式自动切换 |
| 🚀 **代理** | HomeProxy + sing-box | 基于 `nftables` 透明代理，内置 `kmod-nft-tproxy` 依赖 |
| 🛠️ **终端** | TTYD Web Terminal | 网页直接进入 SSH 命令行，无需额外客户端 |
| 🔌 **USB 驱动** | kmod-usb-dwc3 | 完整支持 360 V6 的 USB 3.0 接口硬件识别 |
| 🔥 **网络核心** | firewall4 + nftables | 新版防火墙架构，转发高效，规则灵活 |

---

## 📦 按需安装清单（稳定版源，100% 可用）

> 💡 **前提**：本固件基于 **OpenWrt 24.10 稳定版** 编译，`opkg` 软件源长期冻结。以下为可选插件，按需执行即可。

```bash
# 🔁 第一步：更新软件包索引
opkg update
```

### 🛡️ 去广告（官方轻量级）
> DNS 层过滤，内存占用 < 15MB，规则每日自动更新
```bash
opkg install luci-app-adblock luci-i18n-adblock-zh-cn
```

### 🖨️ USB 打印机共享（支持 Canon MF4400 等）
> 插入打印机后执行，支持 Raw 9100 端口共享
```bash
opkg install kmod-usb-printer p910nd luci-app-p910nd luci-i18n-p910nd-zh-cn
```
> 📌 **关键配置**：Windows 添加打印机时，**必须关闭「启用双向支持」**，否则队列易卡死。

### 🛠️ 系统稳定性 & 网络增强
```bash
# 网络看门狗（断网自动重启）
opkg install luci-app-watchcat

# 动态 DNS（阿里云/腾讯云/Cloudflare）
opkg install luci-app-ddns ddns-scripts_aliyun ddns-scripts_dnspod ddns-scripts-cloudflare

# UPnP 自动端口映射（优化游戏/NAT）
opkg install luci-app-upnp
```

### 📁 USB 存储扩展
```bash
# 网页文件管理器
opkg install luci-app-fileassistant

# Samba4 局域网共享
opkg install luci-app-samba4 samba4-libs
```
> 📌 安装后执行 `/etc/init.d/rpcd restart` 或刷新浏览器，新菜单即可显示。
