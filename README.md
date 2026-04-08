## 🛠️ 固件当前编译状态

> 📌 **说明**：为了保持 128MB NAND 的轻量与稳定，本固件仅内置核心驱动与网络插件，其余功能已完全移至后期 `opkg` 按需安装。

| 类别 | 状态 | 组件说明 |
| :--- | :--- | :--- |
| 🎨 **界面** | ✅ 已内置 | Argon 主题 + 完整简体中文包 |
| 🚀 **代理** | ✅ 已内置 | HomeProxy + sing-box 核心 + nftables 硬件转发 |
| 📶 **无线** | ✅ 已内置 | ath11k 驱动 + QCN9074 固件 (支持 Wi-Fi 6) |
| 🔌 **硬件** | ✅ 已内置 | USB 3.0 控制器驱动 (`kmod-usb-dwc3`) |
| 🛠️ **终端** | ✅ 已内置 | TTYD 网页终端 (支持中文输入) |
| 🖨️ **打印** | ❌ 需自装 | 已移除内置，支持后期 `opkg` 扩展 |
| 🛡️ **过滤** | ❌ 需自装 | 已移除内置，建议使用官方轻量化方案 |

---

## 📦 扩展实验室：按需安装清单 (100% 兼容)

> 💡 **操作指南**：通过 TTYD 或 SSH 进入后台，直接复制粘贴以下命令即可。  
> ✅ 本固件基于 **OpenWrt 24.10 稳定版** 编译，软件源长期冻结，依赖完全匹配。

### 0. 准备工作
```bash
opkg update
```

### 1. 🛡️ 去广告 (官方轻量级)
> DNS 层过滤，内存占用 < 15MB，规则每日自动更新。
```bash
opkg install luci-app-adblock luci-i18n-adblock-zh-cn
```

### 2. 🖨️ USB 打印机共享
> 适配 Canon/HP 等 USB 打印机，支持 Raw 9100 端口。
```bash
opkg install kmod-usb-printer p910nd luci-app-p910nd luci-i18n-p910nd-zh-cn
```
> ⚠️ **Windows 配置**：添加打印机时，必须在端口属性中 **关闭「启用双向支持」**，否则打印队列易卡死。

### 3. 📁 USB 存储与文件管理
> 开启 360 V6 的 NAS 潜质，支持硬盘挂载与局域网共享。
```bash
# 安装文件管理器与 Samba 共享
opkg install luci-app-fileassistant luci-app-samba4 luci-i18n-samba4-zh-cn
```

### 4. 🛠️ 系统稳定性与网络增强
```bash
# 网络看门狗：断网自动重启路由器
opkg install luci-app-watchcat

# DDNS：外网访问（支持阿里/腾讯/Cloudflare）
opkg install luci-app-ddns ddns-scripts_aliyun ddns-scripts_dnspod ddns-scripts-cloudflare

# UPnP：优化游戏机（PS5/Switch）NAT 类型
opkg install luci-app-upnp luci-i18n-upnp-zh-cn
```

---

## ⚠️ 安装后必读
1. **菜单刷新**：安装插件后，若网页未显示新菜单，请执行以下命令刷新后台：
   ```bash
   /etc/init.d/rpcd restart
   ```
2. **空间监控**：360 V6 剩余空间约 50MB+，上述插件可全部安装。若需安装更多重型插件（如 Docker），请参考上文【空间管理】部分进行 USB 扩展。
```
