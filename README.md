# 🚀 360 V6 一键扩展脚本 [v6.0 Ultimate]

> 专为 **128M Flash + 512M RAM** 设备设计。插上 U 盘 → 重启 → 全自动部署 Docker/AdGuardHome/Samba。

---

## 📌 固件功能 vs 脚本扩展
| 类别 | 说明 |
|------|------|
| 🟦 **固件预编译** | ImmortalWrt 原生功能已内置：网络管理/LuCI界面/SmartDNS/HomeProxy/基础Samba/状态监控/系统设置等，**刷入即用**。 |
| 🟩 **本脚本扩展** | 专注解决小闪存瓶颈与重型应用部署：Docker/AGH离线安装、`/tmp`缓存重定向、自愈巡逻、运维工具链、Flash智能保护。 |

---

## ✨ 核心特性
- **🛡️ Flash 零占用**：Docker/AGH 二进制全装 U 盘，系统仅存符号链接 (~5MB)。
- **🔧 `/tmp` 爆满根治**：apk 缓存与临时目录自动重定向至 U 盘，大包安装不失败。
- **🤖 全自动运维**：WAN/U 盘热插拔触发 + 5分钟自愈巡逻 + `install-extras-fix` 一键修复。
- **⚡ 智能保护**：Flash <20MB 中止 / <25MB 跳过插件，永不写爆。
- **📦 运维工具集**：内置状态查询、分级日志、进度监控、配置备份，告别盲猜。

---

## 🚀 快速开始
1. **准备 U 盘**：≥2GB，格式 ext4/FAT32/NTFS。
2. **插入并重启**：刷入 ImmortalWrt 后插入 U 盘，执行 `reboot`。
3. **自动部署**：联网后自动运行，全程约 **5-12 分钟**。
4. **验证状态**：
   ```bash
   360v6-status
   ```

---

## 📁 目录结构 & 常用命令

### 🔹 目录布局
```
U 盘 (/mnt/sda1/)        │  系统 (/)
├── .apk-cache/ & .tmp/  │  ├── /etc/install-{extras,usb}-done  # 完成标记
├── swapfile             │  ├── /overlay/upper/usr/bin/         # 符号链接
├── docker-{system,data}/│  └── /usr/bin/                       # 运维工具
└── adguardhome-*/       │
```

### 🔹 常用命令
| 功能 | 命令 |
|------|------|
| 查看状态/进度 | `360v6-status` / `install-extras-progress --watch` |
| 实时日志 | `install-extras-log --tail` |
| 自动修复 | `install-extras-fix` |
| 配置备份/恢复 | `backup-config.sh backup` / `restore <文件>` |
| 手动重跑 | `rm -f /etc/install-usb-done && /usr/lib/install-extras/install-usb.sh &` |

---

## 🌐 服务访问
| 服务 | 地址 | 默认凭据 |
|------|------|----------|
| LuCI 管理 | `http://192.168.2.1` | root / (空) |
| AdGuardHome | `http://192.168.2.1:3000` | admin / admin |
| Samba 共享 | `\\192.168.2.1` | root / (空) |
| Docker CLI | SSH 登录后执行 `docker ps` | - |

> 💡 若 3000 端口无法访问，临时放行：`iptables -I INPUT -p tcp --dport 3000 -j ACCEPT`

---

## ⚠️ 注意事项 & 快速排查
- **请勿中断**：首次运行需下载解压，断电/拔盘可能导致锁残留。
- **日志输出**：脚本使用 `logger`，终端无回显属正常，请用 `install-extras-log` 查看。
- **Swap 自动挂载**：已写入 `/etc/fstab`，重启无需手动 `swapon`。

| 问题 | 解决 |
|------|------|
| 服务未启动 | 运行 `install-extras-fix` 自动修复网络/挂载/进程 |
| 安装卡住 | `rm -f /tmp/install-*.lock` 清理残留锁后重试 |
| Flash 告急 | `apk cache clean` 清理缓存，脚本会自动降级安装 |

---

> **插上 U 盘 → 重启 → 去睡觉。**  
> 醒来即享完整 Docker/去广告/NAS 环境，运维零干预。📜 MIT License
