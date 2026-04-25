# 🚀 360 V6 一键扩展脚本 [v6.0 Ultimate]

> 专为 **128M Flash + 512M RAM** 设备设计  
> **插上 U 盘 → 重启 → 躺平**

---

## ✅ 功能一览

| 功能 | 说明 |
|------|------|
| **Docker** | 可执行文件+数据全装 U 盘，Flash 零占用 |
| **AdGuardHome** | 配置+数据全装 U 盘，重刷不丢失 |
| **Samba** | Flash ≥25MB 时自动安装，含 LuCI 界面 |
| **Swap** | 256MB 自动创建，激活后写入 fstab |
| **自愈机制** | WAN 上线 / U 盘插入 / 每 5 分钟 cron 自动重试 |
| **Flash 保护** | <20MB 中止，<25MB 跳过可选组件 |
| **运维工具** | `360v6-status` / `install-extras-fix` / `install-extras-log` |

---

## 🚀 快速开始

| 步骤 | 操作 |
|------|------|
| 1️⃣ | 准备 U 盘（≥4GB，ext4/FAT32/NTFS 均可） |
| 2️⃣ | 插入 U 盘，执行 `reboot` |
| 3️⃣ | 等待 5-10 分钟（自动部署） |
| 4️⃣ | `360v6-status` 验证安装 |

---

## 📁 目录结构

```
U 盘/
├── docker-system/          # Docker 可执行文件
├── docker-data/            # 镜像/容器/卷
├── adguardhome-system/     # AGH 可执行文件
├── adguardhome-config/     # AGH 配置
├── adguardhome-data/       # 过滤规则/日志
└── swapfile                # 256MB Swap

系统/
├── /etc/install-usb-mount  # U 盘路径固化
├── /etc/init.d/dockerd     # procd 启动脚本
├── /usr/bin/360v6-status   # 状态查询
└── /usr/lib/install-extras/ # 核心脚本
```

---

## 🔧 常用命令

| 命令 | 说明 |
|------|------|
| `360v6-status` | 查看部署状态 |
| `install-extras-log --tail` | 实时日志 |
| `install-extras-log --error` | 错误日志 |
| `install-extras-fix` | 自动修复 |
| `install-extras-progress` | 安装进度 |

---

## 🌐 服务访问

| 服务 | 地址 | 凭据 |
|------|------|------|
| LuCI | `http://192.168.2.1` | root / (空) |
| AdGuardHome | `http://192.168.2.1:3000` | admin / admin |
| Samba | `\\192.168.2.1` | root / (空) |

---

## ⚠️ 注意事项

| # | 说明 |
|---|------|
| 1 | 首次安装 **5-12 分钟**，请勿断电/拔盘 |
| 2 | 建议 U 盘 **≥8GB**（Docker 镜像较占空间） |
| 3 | 运行时拔盘会导致 Docker/AGH 停止 |
| 4 | 系统升级后重跑 `run.sh` 即可重建链接 |

---

## 🔍 故障排查

```bash
# Docker 无法启动
mount | grep sda1                     # 检查挂载
/etc/init.d/dockerd restart           # 手动重启
logread | grep dockerd                # 查看错误

# 卡住/无日志
rm -f /tmp/install-*.lock             # 清理残留锁
install-extras-log --follow           # 实时监控

# Flash 空间不足
apk cache clean                       # 清理缓存
rm -rf /tmp/*                         # 清理临时文件
```

---

## 📜 日志示例

```
[12:30:01] ▶ v6.0 基础环境启动
[12:30:11] ✅ 网络就绪
[12:31:10] ✅ 基础环境完成 Flash:42%
[12:32:00] ✅ Swap 已激活
[12:34:00] ✅ Docker 已启动
[12:35:30] ✅ AGH 已启动
[12:35:35] 🎉 重型应用完成
```

---

## 🎯 一句话总结

> **插上 U 盘 → 重启 → 去睡觉**  
> 醒来：✅ Docker ✅ AGH ✅ Samba ✅ 自愈 ✅ 备份

---

**Made for 360 V6 / IPQ6000**
```
