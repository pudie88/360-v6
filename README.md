# 🚀 360 V6 一键扩展脚本 [v6.0 Ultimate]

> 专为 **128M Flash + 512M RAM** 设备（360 V6 / 小米 CR660x / IPQ6000）设计的全自动部署方案  
> **插上 U 盘 → 重启 → 躺平**，剩下的交给脚本

---

## 📋 功能说明

### 🔹 **ImmortalWrt 固件已编译功能**（开箱即用）

以下功能在刷入 ImmortalWrt 固件后**立即可用**，无需额外安装：

| 类别 | 功能 | 说明 |
|------|------|------|
| **LuCI 界面** | 完整 Web 管理界面 | 系统配置、网络设置、服务管理 |
| **网络管理** | 接口/无线/路由/DHCP/DNS/防火墙 | 基础网络功能 |
| **系统管理** | 系统设置/管理权限/软件包/启动项/计划任务 | 系统配置工具 |
| **存储管理** | 挂载点/磁盘管理/LED 配置 | 存储设备管理 |
| **备份与更新** | 备份与更新/定时重启/CPU 优化 | 系统维护工具 |
| **服务** | HomeProxy/动态 DNS/SmartDNS/带宽监控/网络唤醒/UPnP | 网络服务 |
| **NAS** | 网络共享（基础 Samba） | 文件共享 |
| **状态监控** | 概览/路由/防火墙/系统日志/进程/信道分析/实时信息 | 系统监控 |

---

### 🔹 **本脚本扩展功能**（自动安装）

以下功能通过本脚本**自动部署**，无需手动配置：

| 功能 | 说明 | 安装位置 |
|------|------|----------|
| **Flash 零占用架构** | Docker/AGH 离线安装到 U 盘，系统仅存符号链接 | `/mnt/sda1/docker-system/` |
| **`/tmp` 爆满根治** | apk 缓存 + TMPDIR 重定向到 U 盘 | `/mnt/sda1/.apk-cache/` |
| **Docker + Dockerd** | 完整 Docker 环境，数据目录自动配置 | U 盘离线安装 |
| **AdGuardHome** | DNS 去广告，配置+数据自动迁移 | U 盘离线安装 |
| **LuCI 管理插件** | luci-app-dockerman / luci-app-adguardhome / luci-app-samba4 | 系统（Flash ≥25MB） |
| **系统工具** | bash / htop / lsblk / smartmontools / fdisk | 系统 |
| **Samba 服务器** | samba4-server + 中文 LuCI 界面 | 系统（Flash ≥25MB） |
| **Swap 管理** | 256MB Swap 自动创建 + fstab 持久化 | `/mnt/sda1/swapfile` |
| **运维工具集** | 360v6-status / install-extras-fix / install-extras-log / install-extras-progress | `/usr/bin/` |
| **健康检查** | health-check.sh / backup-config.sh / resource-monitor.sh / network-test.sh | `/usr/lib/install-extras/` |
| **自动化部署** | WAN/U 盘 hotplug 触发 + cron 自愈巡逻（每 5 分钟） | `/etc/hotplug.d/` + crontab |
| **系统优化** | I/O 调度器（mq-deadline）/ swappiness=10 / DNS 容错 | 系统参数 |
| **Flash 保护** | <20MB 中止安装 / <25MB 跳过可选插件 | 自动检测 |

---

## 🚀 快速开始

### 1️⃣ 准备 U 盘
- **容量**：≥2GB（推荐 8GB+，存放镜像/日志更从容）
- **格式**：ext4（推荐）/ FAT32 / NTFS 均可
- **作用**：存放 Docker 数据、AdGuardHome 配置、Swap 文件、apk 缓存

### 2️⃣ 刷入系统 + 插入 U 盘
```bash
# 1. 刷入 ImmortalWrt（确保已开启 ash + procd 支持）
# 2. 插入 U 盘到任意 USB 口
# 3. 重启设备
reboot
```

### 3️⃣ 等待自动部署（5-12 分钟）
脚本将在以下事件自动触发：
- ✅ WAN 口获取 IP 后 → 安装基础环境
- ✅ U 盘挂载后 → 安装 Docker + AdGuardHome
- ✅ 每 5 分钟自愈巡逻 → 意外中断自动补跑

### 4️⃣ 验证安装
```bash
# 一键查看状态（推荐）
360v6-status

# 或手动验证
[ -f /etc/install-extras-done ] && echo "✅ 基础环境完成"
[ -f /etc/install-usb-done ] && echo "✅ 重型应用完成"
docker info >/dev/null 2>&1 && echo "✅ Docker 运行中"
pgrep AdGuardHome >/dev/null 2>&1 && echo "✅ AGH 运行中"
```

---

## 📁 文件布局

### 🔹 U 盘结构（自动创建）
```
/mnt/sda1/                     # U 盘挂载点（可能为 sdb1/usb 等）
├── .apk-cache/                # apk 包缓存（加速重装）
├── .tmp/                      # 临时目录（替代系统 /tmp）
├── swapfile                   # 256MB Swap 文件（激活后写入 fstab）
├── docker-system/             # Docker 离线安装根目录
│   └── usr/bin/               # docker/dockerd/containerd/runc
├── docker-data/               # Docker 数据目录（镜像/容器/卷）
└── adguardhome-system/        # AGH 离线安装根目录
└── adguardhome-config/        # AGH 配置文件 (AdGuardHome.yaml)
└── adguardhome-data/          # AGH 运行数据 (过滤规则/查询日志)
```

### 🔹 系统内部（自动配置）
```
/etc/
├── install-extras-done        # 基础环境完成标记
├── install-usb-done           # 重型应用完成标记
├── install-usb-mount          # U 盘挂载点固化路径（供 init 脚本读取）
├── install-state/
│   ├── phase1-failures        # 基础环境失败计数（≥3 次停止重试）
│   └── phase2-failures        # 重型应用失败计数
├── docker/daemon.json         # Docker 配置（data-root 指向 U 盘）
├── init.d/dockerd             # procd 风格启动脚本（读固化路径）
├── init.d/adguardhome         # procd 风格启动脚本
└── profile.d/docker-usb.sh    # LD_LIBRARY_PATH 环境变量

/overlay/upper/usr/bin/        # 符号链接目录（重启不丢失）
├── docker -> /mnt/sda1/docker-system/usr/bin/docker
├── dockerd -> .../dockerd
├── AdGuardHome -> .../AdGuardHome
└── ...

/usr/bin/
├── 360v6-status               # 状态查询工具
├── install-extras-fix         # 自动修复工具（网络/挂载/服务）
├── install-extras-log         # 分级日志查看 (--main/--usb/--error/--follow)
└── install-extras-progress    # 安装进度监控 (--watch 实时模式)

/usr/lib/install-extras/
├── run.sh                     # Phase 1: 基础环境部署
├── install-usb.sh             # Phase 2: 重型应用部署（支持 --self-heal）
├── health-check.sh            # 系统健康检查
├── backup-config.sh           # 配置备份/恢复工具
└── resource-monitor.sh        # 资源监控（内存/`/tmp`/僵尸进程）
```

---

## ⚙️ 安装的软件包

### 🔹 基础环境（必装，Flash 保护）
| 软件包 | 作用 | Flash 占用 |
|--------|------|-----------|
| `bash` `htop` `lsblk` `smartmontools` `fdisk` | 系统诊断工具 | ~5MB |
| `samba4-server` | 文件共享（Flash ≥25MB 时安装） | ~15MB |
| `luci-app-samba4` + 中文包 | LuCI 管理界面（Flash ≥25MB 时安装） | ~3MB |

### 🔹 重型应用（需 U 盘，离线安装）
| 软件包 | 安装位置 | 系统占用 |
|--------|----------|----------|
| `docker` + `dockerd` | `/mnt/sda1/docker-system/` | ~5MB（符号链接） |
| `adguardhome` | `/mnt/sda1/adguardhome-system/` | ~2MB（符号链接） |
| `luci-app-dockerman` + 中文包 | 系统（Flash ≥25MB 时安装） | ~8MB |
| `luci-app-adguardhome` | 系统（Flash ≥25MB 时安装） | ~3MB |

> 💡 **Flash 保护策略**：  
> • <20MB 剩余：中止安装，防止变砖  
> • 20-25MB 剩余：仅装基础工具，跳过 LuCI 插件  
> • ≥25MB 剩余：完整安装所有组件  

---

## 🔧 常用命令

### 🔹 状态查询
```bash
360v6-status                    # 一键查看部署状态
install-extras-progress         # 查看安装进度
install-extras-progress --watch # 实时监控模式（每 2 秒刷新）
```

### 🔹 日志查看
```bash
install-extras-log --tail       # 实时跟踪安装日志
install-extras-log --main       # 仅看基础环境日志
install-extras-log --usb        # 仅看重型应用日志
install-extras-log --error      # 仅看错误日志
logread -f | grep -E 'main|usb' # 原生命令实时过滤
```

### 🔹 故障修复
```bash
install-extras-fix              # 自动修复网络/挂载/服务/清理
360v6-status                    # 修复后验证状态
```

### 🔹 配置备份
```bash
# 备份当前配置到 U 盘
/usr/lib/install-extras/backup-config.sh backup

# 列出可用备份
/usr/lib/install-extras/backup-config.sh list

# 恢复指定备份（需确认）
/usr/lib/install-extras/backup-config.sh restore /mnt/sda1/backup-config/config_20260425_120000.tar.gz
```

### 🔹 手动重跑
```bash
# 重跑基础环境
rm -f /etc/install-extras-done /etc/install-state/phase1-failures
/usr/lib/install-extras/run.sh &

# 重跑重型应用
rm -f /etc/install-usb-done /etc/install-state/phase2-failures
/usr/lib/install-extras/install-usb.sh /mnt/sda1 &
```

---

## 🌐 访问服务

| 服务 | 地址 | 默认凭据 | 说明 |
|------|------|----------|------|
| **LuCI 管理界面** | `http://192.168.2.1` | root / (空) | 系统配置 |
| **AdGuardHome** | `http://192.168.2.1:3000` | admin / admin | DNS 去广告 |
| **Samba 共享** | `\\192.168.2.1` (Windows) | root / (空) | 文件共享 |
| **Docker CLI** | SSH 登录后执行 `docker ps` | - | 容器管理 |

> ⚠️ **防火墙提示**：如无法访问 3000 端口，临时放行：
> ```bash
> iptables -I INPUT -p tcp --dport 3000 -j ACCEPT
> ```

---

## ⚠️ 注意事项

1. **首次安装耗时**：约 `5-12 分钟`（网络下载 + U 盘解压 + 链接建立），**请勿断电/拔盘**。
2. **日志查看方式**：脚本全部使用 `logger` 输出至系统日志，终端无直接回显属正常现象。使用 `install-extras-log --tail` 监控。
3. **U 盘热插拔**：拔出后 Docker/AGH 服务会停止，插入后 `hotplug` 或 `cron` 会自动拉起。
4. **系统升级后**：若 ImmortalWrt 大版本升级导致 `/overlay` 重置，只需重跑一次 `run.sh`，符号链接会自动重建。
5. **Swap 自动挂载**：脚本已自动写入 `/etc/fstab`，重启后无需手动 `swapon`。
6. **备份建议**：首次安装完成后，执行 `/usr/lib/install-extras/backup-config.sh backup` 创建初始备份。

---

## 🔍 故障排查

### ❌ Docker 无法启动
```bash
# 1. 检查 U 盘是否挂载
mount | grep sda1

# 2. 检查符号链接
ls -la /overlay/upper/usr/bin/docker

# 3. 手动启动并查看错误
/etc/init.d/dockerd start
logread | grep dockerd | tail -10

# 4. 重跑重型应用
rm -f /etc/install-usb-done
/usr/lib/install-extras/install-usb.sh /mnt/sda1 &
```

### ❌ AdGuardHome 无法访问 3000 端口
```bash
# 1. 检查进程
pgrep -a AdGuardHome

# 2. 检查防火墙
iptables -L INPUT -n | grep 3000

# 3. 临时放行
iptables -I INPUT -p tcp --dport 3000 -j ACCEPT

# 4. 重启服务
/etc/init.d/adguardhome restart
```

### ❌ 安装卡住/无日志输出
```bash
# 1. 检查锁文件（可能残留）
ls -la /tmp/install-*.lock
cat /tmp/install-usb.lock 2>/dev/null

# 2. 清理锁并重试
rm -f /tmp/install-*.lock /etc/install-usb-done
/usr/lib/install-extras/install-usb.sh /mnt/sda1 &

# 3. 查看实时日志
install-extras-log --follow
```

### ❌ Flash 空间不足
```bash
# 1. 查看使用率
df -h /overlay

# 2. 清理缓存
apk cache clean

# 3. 删除无用包
apk del --no-cache 包名

# 4. 重跑安装（会自动跳过可选组件）
rm -f /etc/install-extras-done
/usr/lib/install-extras/run.sh &
```

---

## 📜 运行日志示例

```
[12:30:01] ▶ v6.0 基础环境启动
[12:30:11] ✅ 网络就绪，临时 DNS 已注入
[12:30:15] ✅ U 盘已挂载: /mnt/sda1
[12:30:20] ⚡ I/O 调度器: mq-deadline
[12:30:25] ✅ Swap 256MB 已激活 + 写入 fstab
[12:30:40] ✅ apk update 成功 (10529 packages)
[12:31:10] 📦 安装: bash htop lsblk smartmontools fdisk
[12:32:45] ✅ Docker 已启动 | data-root: /mnt/sda1/docker-data
[12:33:20] ✅ AGH 已启动 | config: /mnt/sda1/adguardhome-config
[12:33:25] 🎉 重型应用完成 [Docker:OK AGH:OK]
[12:33:26] ✅ v6.0 Ultimate 部署完成！Flash: 42%
```

---

## 🎯 一句话总结

> **插上 U 盘 → 重启 → 去睡觉**  
> 醒来时：✅ Samba ✅ Docker ✅ AdGuardHome ✅ 自愈巡逻 ✅ 配置备份  
> 全部全自动部署完毕，运维零干预。

---

## 📄 许可证 & 贡献

- **许可证**：MIT（自由使用/修改/分发）
- **适用固件**：ImmortalWrt SNAPSHOT / IPQ6000 系列
- **问题反馈**：请提供 `360v6-status` 输出 + `install-extras-log --error` 日志
- **贡献建议**：欢迎提交 PR 优化兼容性/性能/文档

---

> 💡 **最后提醒**：  
> 🔹 **128M Flash 设备**：此脚本是「救命方案」，离线安装 + 符号链接是刚需  
> 🔹 **生产环境**：建议首次安装后执行 `backup-config.sh backup` 创建基线备份  
> 🔹 **学习参考**：代码注释清晰，可作为嵌入式自动化部署范本阅读  
>   
> **祝部署顺利，躺平愉快！** 🛌
