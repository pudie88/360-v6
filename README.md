```markdown
# OpenWrt for 360 V6 (Qualcomm IPQ60xx)

自动构建适用于 **奇虎 360 V6** 路由器的 OpenWrt 固件，基于 GitHub Actions 全自动编译。

---

## 📦 固件特性

| 功能 | 状态 |
|------|------|
| 中文界面 | ✅ |
| Argon 主题 | ✅ |
| HomeProxy + Sing-Box | ✅ |
| ttyd 网页终端 | ✅ |
| USB 3.0 驱动（DWC3） | ✅ |
| ath11k 无线驱动 | ✅ |
| dnsmasq-full | ✅ |
| nftables 防火墙 | ✅ |

---

## ⬇️ 下载固件

前往 [Releases](../../releases) 页面下载最新版本。

| 文件 | 用途 |
|------|------|
| `*-factory.ubi` | 首次刷入（从原厂固件） |
| `*-sysupgrade.bin` | 已有 OpenWrt 时升级使用 |

---

## 🔧 刷机说明

### 首次刷入
1. 登录路由器原厂管理界面
2. 找到固件升级页面
3. 上传 `*-factory.ubi` 文件
4. 等待重启完成

### 升级 OpenWrt
1. 登录 LuCI 管理界面 → 系统 → 备份/升级
2. 上传 `*-sysupgrade.bin` 文件
3. 等待重启完成

### 刷机后默认信息
- **管理地址**：http://192.168.1.1
- **用户名**：root
- **密码**：（空，直接回车）

---

## 🛠️ 手动编译

如需自行编译，克隆本仓库后触发 GitHub Actions 即可：

```bash
git clone https://github.com/你的用户名/你的仓库名
# 修改 .config 后推送，自动触发构建
git add .config
git commit -m "update config"
git push
```

或在 GitHub 仓库页面 → **Actions** → **Build OpenWrt for 360 V6** → **Run workflow** 手动触发。

---

## ⚙️ 修改编译配置

编辑仓库根目录的 `.config` 文件即可增减软件包，推送后自动重新编译。

常用配置示例：

```ini
# 添加一个包
CONFIG_PACKAGE_包名=y

# 禁用一个包
# CONFIG_PACKAGE_包名 is not set
```

---

## 📋 设备信息

| 项目 | 参数 |
|------|------|
| 设备 | 奇虎 360 V6 |
| SoC | Qualcomm IPQ6000 |
| 架构 | ARM64 |
| Target | qualcommax / ipq60xx |
| 无线 | ath11k（2.4G + 5G） |
| 闪存 | 128MB NAND |
| 内存 | 256MB DDR |

---

## ⚠️ 免责声明

刷机有风险，操作需谨慎。固件仅供学习交流使用，因刷机导致的设备损坏概不负责。

---

## 📄 License

基于 [OpenWrt](https://github.com/openwrt/openwrt) 构建，遵循 GPL-2.0 协议。
```

去睡吧，明天编译好了看 Release 页面 🌙
