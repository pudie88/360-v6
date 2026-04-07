# OpenWrt 自动编译 — 360 V6

基于 GitHub Actions 自动编译适配 360 V6 路由器的 OpenWrt 固件。

## 设备信息

| 项目 | 参数 |
|------|------|
| 设备 | 360 V6 全屋路由 |
| 芯片 | Qualcomm IPQ6000（四核 A53 1.2GHz）|
| 内存 | 512MB |
| 闪存 | 128MB NAND |
| 无线 | Wi-Fi 6 双频 AX1800 |
| 接口 | 4 × 千兆 LAN/WAN + 1 × USB 2.0 |
| OpenWrt Target | qualcommax / ipq60xx |

## 内置功能

- **HomeProxy** — 代理工具（基于 sing-box）
- **ttyd** — 网页终端
- **Argon** — 现代化主题
- **中文界面** — 全中文 LuCI

## 固件下载

前往 [Releases](../../releases) 页面下载最新固件。

| 文件 | 用途 |
|------|------|
| `*-squashfs-factory.ubi` | 全新刷入（通过 uboot）|
| `*-initramfs-uImage.itb` | 内存启动测试用，重启后消失 |

## 刷机方法

### 从原厂固件刷入

1. 用网线连接路由器任意 LAN 口
2. 按住 Reset 键同时上电，等红灯亮起后松开，进入 uboot
3. 电脑网卡设置静态 IP：`192.168.1.10`，网关：`192.168.1.1`
4. 浏览器打开 `192.168.1.1` 进入 uboot 页面
5. 选择 `factory.ubi` 文件上传刷入
6. 等待重启完成

### 从 OpenWrt 升级

```bash
sysupgrade -v /tmp/openwrt-*-sysupgrade.tar
```

## 首次登录

| 项目 | 默认值 |
|------|--------|
| 管理地址 | http://192.168.1.1 |
| 用户名 | root |
| 密码 | 无（直接回车）|

## 编译说明

本仓库使用 GitHub Actions 自动编译，基于 OpenWrt `main` 分支（snapshot）。

手动触发编译：Actions → Build OpenWrt for 360 V6 → Run workflow

每次 push 修改 `.github/workflows/openwrt-builder.yml` 也会自动触发编译。

编译时间约 3～4 小时。

## 注意事项

- 固件基于 snapshot 分支，功能最新但稳定性不如正式版
- 刷机有风险，请确认文件正确后再操作
- 如遇问题可通过 uboot 重新刷入恢复
