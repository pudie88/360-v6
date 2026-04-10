# OpenWrt 360 V6 自动编译

基于 ImmortalWrt master 分支，使用 GitHub Actions 自动编译 360 V6 固件。

## 设备信息

| 项目 | 内容 |
|------|------|
| 设备 | 奇虎 360 V6 |
| SoC | Qualcomm IPQ6018 |
| 架构 | aarch64_cortex-a53 |
| 目标 | qualcommax/ipq60xx |

## 内置功能

- 中文界面 + Argon 主题
- HomeProxy + sing-box 代理
- ttyd 网页终端
- USB 3.0 驱动
- ath11k 无线驱动
- curl / wget / htop / bash 等常用工具

## 使用方法

### 触发编译

- 推送代码到 `main` 或 `master` 分支时自动触发
- 修改 `.config` 或 workflow 文件时自动触发
- 在 Actions 页面手动点击 `Run workflow`

### 下载固件

编译完成后在 [Releases](../../releases) 页面下载，有两个文件：

- `*-squashfs-sysupgrade.bin` — 从 OpenWrt/ImmortalWrt 刷入用
- `*-squashfs-factory.ubi` — 从原厂固件刷入用

### 刷入方法

在 LuCI 管理页面 `系统 → 备份/升级 → 刷写新固件` 上传 sysupgrade 文件即可。

## 验证固件

刷入后通过 ttyd 或 SSH 运行：
```bash
cat /tmp/sysinfo/board_name
# 应输出：qihoo,360v6
```

## 自定义配置

修改仓库根目录的 `.config` 文件，推送后自动触发编译。

## 注意事项

- 官方 OpenWrt 24.10 **不支持** 360 V6，必须使用 ImmortalWrt master 分支
- 编译时间约 60-90 分钟
- 固件为 SNAPSHOT 版本，版本号为 git commit 短哈希
